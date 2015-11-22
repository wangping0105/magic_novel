class UserHome::BooksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :store_location

  def index
    @collection_books = current_user.collection_books
  end

  def update

  end

  private

 
end
