class EossanguosWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    eos_sanguo_switch = Rails.cache.read(:eos_sanguo_switch) || true

    puts eos_sanguo_switch
    if eos_sanguo_switch
      Rails.cache.write(:eos_sanguo_switch, false)

      trx_time = EosSanguo.order(trx_time: :desc).first.try(:trx_time) || (Time.now - 30.days).to_s
      EosSanguo.fetch_data(trx_time, repeat_end: false)

      Rails.cache.write(:eos_sanguo_switch, true)
    else
      puts "已经有任务运行"
    end
  end
end