class UpdateBookWorker
  include Sidekiq::Worker

  def perform(id)
    book = Book.find_by(id: id)
    Crawler::Fenghuo.update_book(book)
  end
end