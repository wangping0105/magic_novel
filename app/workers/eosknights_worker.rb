class EosknightsWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    eos_knight_switch = Rails.cache.read(:eos_knight_switch) || true

    puts eos_knight_switch
    if eos_knight_switch
      Rails.cache.write(:eos_knight_switch, false)

      eos = EosKnight.order(trx_time: :desc).first
      EosKnight.fetch_data(eos.trx_time, repeat_end: false)

      Rails.cache.write(:eos_knight_switch, true)
    else
      puts "已经有任务运行"
    end
  end
end