class ManagementsController < ApplicationController
  before_action :admin_authority?

  def index
    @books = Book.pending_books.includes(:author, :classification)
    @books = filter_page(@books)
  end

  def create
    titles = params[:skip_titles].split(",")
    book_urls = Rails.cache.read(:book_urls) || []
    if params[:url].present? && !book_urls.include?(params[:url])
      flash.now[:success] = '成功提交'
      DownloadBookWorker.perform_async(params[:url], titles)
      book_urls << params[:url]
      Rails.cache.write(:book_urls, book_urls)
    else
      flash.now[:danger] = []
      flash.now[:danger] << 'url 不能为空' if params[:url].blank?
      flash.now[:danger] << '已经添加过该小说' if book_urls.include?(params[:url])
    end

    render 'new'
  end

  def new

  end

  def tab_books
    param! :book_type, String, required: false
    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).order("click_count desc").limit(9)
  end
end
