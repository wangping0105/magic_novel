class DownloadBookWorker
  include Sidekiq::Worker

  def perform(chapters_url, skip_titles)
    # http://book.fenghuo.in/readbook.php?aid=50955&pno=0
    Crawler::Fenghuo.download_single_book(chapters_url, skip_titles: skip_titles)
  end
end