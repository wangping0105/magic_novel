class BookChaptersController < ApplicationController
  before_action :set_book
  before_action :authenticate_user!

  def index
    @books = Book.all
    @books = filter_page(@books)
  end

  def new
    @book_chapter = @book.book_chapters.new
    @book_volumes = @book.book_volumes.order(id: :desc).map{|k| [k.title, k.id]}
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

  def get_chapter
    set_book_volume
    @chapter = @book_volume.book_chapters.last

    render json:{id: @chapter.try(:id).to_i, name: @chapter.try(:title).to_s}
  end

  private

  def params_book
    params.require(:book).permit(:title, :classification_id, :book_type, :introduction, :remarks)
  end

  def set_book_volume
    @book_volume = @book.book_volumes.find(params[:book_volume_id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end
end
