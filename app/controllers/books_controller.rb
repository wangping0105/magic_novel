class BooksController < ApplicationController
  before_action :set_book, only: [
    :edit, :update, :show, :destroy, :collection, :uncollection, :settings, :save_settings, :update_single_book
  ]
#  before_action :authenticate_user!
  def index
    set_page_title('魔·书库')
    @books = Book.online_books.includes(:author, :classification)
    @books = filter_params(@books)
    @books = filter_page(@books)
    @books = filter_order(@books)

    @classifications = Rails.cache.fetch("classification_counts", expires_in: 1.seconds) do
      classifications = Classification.all
      class_arr = Book.online_books.group(:classification_id).pluck("books.classification_id, count(*) total_count").to_h
      classifications.map{|c|
        book_count = class_arr[c.id].to_i
        [c.name, c.id, book_count]
      }
    end

    @all_book_count = @classifications.map(&:last).sum

    respond_to do |format|
      format.html
    end
  end

  def new
    @book = Book.new
    @classifications = Classification.all.map{|c| [c.name, c.id]}
  end

  def show
    set_page_title(@book.title)
    # 这边不佳 id >0  查询会很慢
    @book_chapters = @book.book_chapters.where("id > 0").includes(:book_volume).page(params[:page]).per_page(128)
    if params[:order_type] == "desc"
      @book_chapters = @book_chapters.order(book_volume_id: :desc).order(id: :desc)
    else
      @book_chapters = @book_chapters.order(book_volume_id: :asc).order(id: :asc)
    end

    # @book_volumns = @book.book_volumes.includes(:book_chapters)
    @collection = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation.relation_type_options.select{|a| a[0]=='收藏'}[0][1])
  end

  def create
    _params_book =  params_book.merge(author_id: current_author.id)
    @book = Book.new(_params_book)

    if params_book['book_type'].to_i == 1
      raise_error(params[:author_name].blank? , "作者名不能为空！")
      author = Author.find_or_create_by(name: params[:author_name])
      _params_book[:author_id] = author.id
      _params_book[:operator_id] = current_user.id
    end

    if @book.save
      tags = params[:tag_names].split(";")
      tags.each {|t| BookTagRelation.create(tag: t, book: @book) }
      flash[:success] = "创建成功"
      redirect_to book_path(@book.id)
    else
      @classifications = Classification.all.map{|c| [c.name, c.id]}
      flash[:danger] = "创建失败, #{simple_error_message(@book)}"
      render 'new'
    end
  rescue Exception => e #如果上面的代码执行发生异常就捕获
    @classifications = Classification.all.map{|c| [c.name, c.id]}
    flash[:danger] = e.message
    render 'new'
  end

  def edit
    @classifications = Classification.all.map{|c| [c.name, c.id]}
    render 'new'
  end

  def update
    _params_book =  params_book.merge(author_id: current_author.id)
    @book.assign_attributes(_params_book)

    if params_book['book_type'].to_i == 1
      raise_error(params[:author_name].blank? , "作者名不能为空！")
      author = Author.find_or_create_by(name: params[:author_name])
      _params_book[:author_id] = author.id
      _params_book[:operator_id] = current_user.id
    end

    if @book.save
      tags = params[:tag_names].split(";")
      tags.each {|t| BookTagRelation.create(tag: t, book: @book) }
      flash[:success] = "更新成功"
      redirect_to book_path(@book.id)
    else
      @classifications = Classification.all.map{|c| [c.name, c.id]}
      flash[:danger] = "更新失败, #{simple_error_message(@book)}"
      render 'new'
    end
  rescue Exception => e #如果上面的代码执行发生异常就捕获
    @classifications = Classification.all.map{|c| [c.name, c.id]}
    flash[:danger] = e.message
    render 'new'
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

  def collection
    book_relation = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation::COLLECTION)
    unless book_relation
      book_relation = BookRelation.new(book: @book, user: current_user, relation_type: BookRelation::COLLECTION)
      if book_relation.save
        book_count_change("collection", "+")

        unless current_user.book_marks.where(book: @book).exists?
          book_chapter = @book.book_chapters.last
          BookMark.create(book_chapter: book_chapter, user: current_user, book: @book)
        end
      else
        error_messages = book_relation.errors.messages.map do |k, msg|
          t("errors.models.book_relation.#{k}", count: msg.join(","))
        end

        flash[:danger] = "添加收藏失败，#{error_messages.join(",")}"
        redirect_to book_path(@book) and return
      end
    end

    flash[:success] = "添加收藏成功"
    redirect_to book_path(@book)
  end

  def uncollection
    @collection = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation::COLLECTION)
    if @collection
      @collection.destroy
      book_count_change("collection", "-")
    end

    flash[:success] = "取消收藏成功"
    redirect_to book_path(@book)
  end

  def csv_export
    ExportWorker.perform_async(params)
    render json: {data:0}
  end

# 提交上线
  def commit_pending
    @book = Book.find(params[:id])
    if @book.update(status: Book::PENDING)
      render json: {code: 0}
    else
      render json: {code: -1, messsage: '提交失败！'}
    end
  end

# 审核成功
  def approve_pass
    @book = Book.find(params[:id])
    if @book.update(status: Book::SERIAL)
      render json: {code: 0}
    else
      render json: {code: -1, messsage: '审核成功！'}
    end
  end

# 审核失败
  def approve_failure
    @book = Book.find(params[:id])
    if @book.update(status: Book::FAILURE)
      render json: {code: 0}
    else
      render json: {code: -1, messsage: '审核失败！'}
    end
  end

  def settings

  end

  def save_settings
    @book.update(status: params[:book][:status])
    @book.newest_chapter.update(download_url: params[:download_url])
    flash[:success] = "更新成功"

    redirect_to settings_book_path(@book.id)
  end

  def update_single_book
    UpdateBookWorker.perform_async(@book.id)
    flash[:success] = "更新中。。。"

    redirect_to settings_book_path(@book.id)
  end
  # ======================================================================================
  private
  def params_book
    params_encoded params.require(:book).permit(:title, :classification_id, :book_type, :introduction, :remarks)
  end

  def set_book
    @book = Book.find(params[:id])

    unless current_user && (current_user.admin? || current_author && current_author.is_author_of?(@book))
      @book = Book.online_books.find(params[:id])
    end
  end

  def filter_params(relation)
    if params[:title].present?
      relation = relation.joins("inner join authors a on a.id=books.author_id ")
      relation = relation.where("a.name like :title or title like :title or pinyin like :title ", title: "%#{params[:title]}%")
    end

    relation = relation.where(classification: params[:classification]) if params[:classification].present?

    relation
  end

  def filter_order(relation)
    params[:sort] ||= "click_count"

    relation = relation.order("#{params[:sort]} desc") if params[:sort].present?
    relation = relation.order("click_count desc")
    relation
  end

  def book_count_change(attr_name, operation)
    sql = "update books set #{attr_name}_count = collection_count #{operation} 1 where id = #{@book.id}"
    ActiveRecord::Base.connection.execute(sql)
  end
end
