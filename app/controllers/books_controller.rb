class BooksController < ApplicationController
  before_action :set_book, only: [:show]
#  before_action :authenticate_user!


  def index
    binding.pry
    @books = Book.all
    @books = filter_page(@books)
  end

  def new
    @book = Book.new
    @classifications = Classification.all.map{|c| [c.name, c.id]}
  end

  def show ;end

  def create
    @book = Book.new(params_book.merge(author_id: current_author.id))
    if @book.save
      tags = params[:tag_names].split(";")
      tags.each {|t|
        BookTagRelation.create(tag: t, book: @book)
      }
      redirect_to books_path
    else
      render 'new'
    end
  end

  def update

  end
  private

  def params_book
    params.require(:book).permit(:title, :classification, :book_type, :introduction, :remarks)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end
end
