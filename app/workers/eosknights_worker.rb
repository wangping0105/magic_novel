class EosknightsWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    set_time ||= (Time.now.at_beginning_of_day - 8.hours-5.minutes)
    EosKnight.fetch_data(set_time)
  end
end