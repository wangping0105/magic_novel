class EosknightsWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    # set_time ||= (Time.now - 485.minutes)

    eos = EosKnight.order(trx_time: :desc).first
    EosKnight.fetch_data(eos.trx_time, repeat_end: false)
  end
end