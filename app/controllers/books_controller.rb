class BooksController < ApplicationController
  before_action :set_book, only: [:show]
#  before_action :authenticate_user!


  def index

  end

  def new

  end

  def show ;end

  def update

  end
  private

  def set_book
    @book = Book.find(params[:id])
  end
end
