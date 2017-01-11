class Hybird::HomeController < Hybird::BaseController

  def index
    @books = Book.online_books.includes(:classification).order("click_count desc").limit(9)
  end

  def tab_books
    param! :book_type, String, required: false

    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).order("(click_count/book_chapters_count) desc").limit(9)
  end
end
