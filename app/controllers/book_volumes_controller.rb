class BookVolumesController < ApplicationController
  before_action :set_book
  before_action :authenticate_user!

  def index
    @book_volumes = @book.book_volumes || []
  end

  def create
    _prev_book_volume = @book.book_volumes.last
    book_volume = @book.book_volumes.new(params_book_volume.merge(prev_volume_id: _prev_book_volume.try(:id)))
    if (_prev_book_volume && _prev_book_volume.book_chapters.present?) || !_prev_book_volume.present?
      if book_volume.save
        _prev_book_volume.update(next_volume_id: book_volume.id) if _prev_book_volume.present?
        flash[:success] = '保存成功'
        redirect_to book_book_volumes_path
      else
        flash[:danger] = '保存失败'
        redirect_to book_book_volumes_path(@book)
      end
    else
      flash[:danger] = '保存失败,上一卷标必须有章节'
      redirect_to book_book_volumes_path(@book)
    end
  end

  def update
  end

  private

  def params_book_volume
    params.require(:book_volume).permit(:title)
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def filter_page(relation)
    relation = relation.page(params[:page]).per(params[:per_page])
    relation
  end
end
