class DownloadBooksWorker
  include Sidekiq::Worker

  def perform
    Crawler::Fenghuo.update_books
  end
end