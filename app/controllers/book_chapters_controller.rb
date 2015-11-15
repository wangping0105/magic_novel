class BookChaptersController < ApplicationController
  before_action :set_book
  before_action :authenticate_user!, only:[ :create, :new]
  before_action :set_book_chapter, only: [:show, :edit, :update]

  def index
    @books = Book.all
    @books = filter_page(@books)
  end

  def new
    @book_chapter = @book.book_chapters.new
    @book_volumes = @book.book_volumes.order(id: :desc).map{|k| [k.title, k.id]}
  end

  def show ;end

  def edit
    @book_volumes = @book.book_volumes.order(id: :desc).map{|k| [k.title, k.id]}
  end

  def create
    prev_book_chapter = BookChapter.find_by(id: params_book_chapter[:prev_chapter_id])
    _prev_book_chapter_next = BookChapter.find_by(id: prev_book_chapter.next_chapter_id)
    @book_chapter = @book.book_chapters.new(params_book_chapter.merge(
                                                prev_chapter_id: prev_book_chapter.try(:id),
                                                next_chapter_id: _prev_book_chapter_next.try(:id)
                                            ))
    if @book_chapter.save
      prev_book_chapter.update(next_chapter_id: @book_chapter.id)  if prev_book_chapter.present?
      _prev_book_chapter_next.update(prev_chapter_id: @book_chapter.id)  if _prev_book_chapter_next.present?
      flash[:success] = '创建成功'
      redirect_to book_path(@book)
    else
      flash[:danger] = "创建失败，#{@book.errors.messages}"
      render 'new'
    end
  end

  def update
    if @book_chapter.update(params_book_chapter)
      flash[:success] = '更新成功'
      redirect_to book_book_chapter_path(@book, @book_chapter)
    else
      flash[:danger] = '更新失败'
      render 'edit'
    end
  end

  def get_chapter
    set_book_volume
    @chapter = @book_volume.book_chapters.last
    if @chapter.nil?
      prev_book_volume = @book_volume.prev_volume
      @chapter = prev_book_volume.book_chapters.last
    end

    render json:{
               id: @chapter.try(:id),
               name: @chapter.try(:title).to_s
           }
  end

  private

  def params_book_chapter
    params.require(:book_chapter).permit(:title, :content, :book_volume_id, :prev_chapter_id)
  end

  def set_book_chapter
    @book_chapter = @book.book_chapters.find(params[:id])
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
