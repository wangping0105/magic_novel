class BooksController < ApplicationController
  before_action :set_book, only: [:show, :destroy]
#  before_action :authenticate_user!
  def index
    @books = Book.all
    @books = filter_page(@books)
  end

  def new
    @book = Book.new
    @classifications = Classification.all.map{|c| [c.name, c.id]}
  end

  def show
    @book_volumns = @book.book_volumes.includes(:book_chapters)
  end

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

  def destroy
    if @book.destroy
      flash[:success] = '删除成功'
      redirect_to books_path
    else
      flash[:danger] = '删除失败'
      redirect_to books_path
    end
  end
  private

  def params_book
    params.require(:book).permit(:title, :classification_id, :book_type, :introduction, :remarks)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end
end