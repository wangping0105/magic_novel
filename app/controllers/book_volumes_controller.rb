class BookVolumesController < ApplicationController
  before_action :set_book
  before_action :authenticate_user!

  def index
    @book_volumes = @book.book_volumes || []
  end

  def create
    book_volume = @book.book_volumes.new(params_book_volume)
    if book_volume.save
      flash[:success] = '保存成功'
      redirect_to book_book_volumes_path
    else
      flash[:success] = '保存失败'
      redirect_to 'index'
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
