class DownloadBooksWorker
  include Sidekiq::Worker

  def perform
    Book.find_each do |b|
      Crawler::Fenghuo.update_book(b)
    end
  end
end