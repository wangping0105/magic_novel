class ManagementsController < ApplicationController
  def index
    admin_authority?(current_user)
    @books = Book.pending_books.includes(:author, :classification)
    @books = filter_page(@books)
  end

  def show

  end

  def tab_books
    param! :book_type, String, required: false
    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).order("click_count desc").limit(9)
  end
end
