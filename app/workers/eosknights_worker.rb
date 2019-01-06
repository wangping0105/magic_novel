class EosknightsWorker
  include Sidekiq::Worker

  def perform(set_time = nil)
    set_time ||= Time.now.at_beginning_of_day
    EosKnight.fetch_data(set_time)
  end
end