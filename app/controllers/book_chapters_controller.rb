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
    @book_chapter = @book.book_chapters.new(params_book_chapter)
    if @book_chapter.save
      @prev_book_chapter = BookChapter.find_by(id: params_book_chapter[:prev_chapter_id])
      @prev_book_chapter.update(next_chapter_id: @book_chapter.id) if @prev_book_chapter.present?
      redirect_to book_path(@book)
    else
      render 'new'
    end
  end

  def update
  end

  def get_chapter
    set_book_volume
    @chapter = @book_volume.book_chapters.last
    render json:{
               id: @chapter.try(:id),
               name: @chapter.try(:title).to_s
           }
  end

  private

  def params_book_chapter
    params.require(:book_chapter).permit(:title, :content, :book_volume_id, :prev_chapter_id)
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
