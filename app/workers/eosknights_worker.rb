class EosknightsWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    set_time ||= (Time.now - 450.minutes)
    EosKnight.fetch_data(set_time, repeat_end: false)
  end
end