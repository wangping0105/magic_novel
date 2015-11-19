class BooksController < ApplicationController
  before_action :set_book, only: [:show, :destroy]
#  before_action :authenticate_user!
  def index
    @books = Book.all
    @books = filter_page(@books)
    @books = filter_params(@books)
    @books = filter_order(@books)
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
    _book_name = @book.title
    if @book.destroy
      flash[:success] = "#{_book_name}删除成功"
      redirect_to books_path
    else
      flash[:danger] = '删除失败'
      redirect_to books_path
    end
  end

  private

  def params_book
    params_encoded params.require(:book).permit(:title, :classification_id, :book_type, :introduction, :remarks)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end

  def filter_params(relation)
    if params[:title].present?
      relation = relation.where("title like :title or pinyin like :title ", title: "%#{params[:title]}%")
    end
    relation
  end

  def filter_order(relation)

    relation.order(click_count: :asc).order(id: :asc)
  end
end