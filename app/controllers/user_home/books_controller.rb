class UserHome::BooksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :store_location

  def index
    @page_title = "我的书架"
    @collection_books = current_user.collection_books.includes(book:[:classification, book_marks: :book_chapter]).
      joins("left join book_marks bm on book_relations.book_id = bm.book_id").order('book_marks.updated_at desc').distinct
  end

  def update

  end

  private

 
end
