class BooksController < ApplicationController
  before_action :set_book, only: [:edit, :update, :show, :destroy, :collection, :uncollection]
#  before_action :authenticate_user!
  def index
    params[:sort] ||= "id"
    @books = Book.online_books.includes(:author, :classification)
    @books = filter_page(@books)
    @books = filter_params(@books)
    @books = filter_order(@books)
    @all_book_count = 0
    @classifications = Classification.all
    class_arr = filter_params(Book.online_books).group(:classification_id).pluck("classification_id, count(*) total_count").to_h

    @classifications = @classifications.map{|c|
      book_count = if c.name == "其他"
        class_arr[nil].to_i
      else
        class_arr[c.id].to_i
      end

      @all_book_count += book_count
      [c.name, c.id, book_count]
    }
    respond_to do |format|
      format.html
    end
  end

  def new
    @book = Book.new
    @classifications = Classification.all.map{|c| [c.name, c.id]}
  end

  def show
    @book_chapters = @book.book_chapters.includes(:book_volume).order(book_volume_id: :asc).order(id: :asc).page(params[:page]).per(128)
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
      BookRelation.create(book: @book, user: current_user, relation_type: BookRelation::COLLECTION)
      count_change("collection", "+")
    end

    flash[:success] = "添加收藏成功"
    redirect_to book_path(@book)
  end

  def uncollection
    @collection = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation::COLLECTION)
    if @collection
      @collection.destroy
      count_change("collection", "-")
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

# 提交上线
  def approve_pass
    @book = Book.find(params[:id])
    if @book.update(status: Book::SERIAL)
      render json: {code: 0}
    else
      render json: {code: -1, messsage: '审核失败！'}
    end
  end

# 提交上线
  def approve_failure
    @book = Book.find(params[:id])
    if @book.update(status: Book::FAILURE)
      render json: {code: 0}
    else
      render json: {code: -1, messsage: '审核失败！'}
    end
  end
  # ======================================================================================
  private
  def params_book
    params_encoded params.require(:book).permit(:title, :classification_id, :book_type, :introduction, :remarks)
  end

  def set_book
    if current_user && current_user.admin?
      @book = Book.find(params[:id])
    else
      @book = Book.online_books.find(params[:id])
    end
  end

  def filter_params(relation)
    relation = relation.where("title like :title or pinyin like :title ", title: "%#{params[:title]}%") if params[:title].present?
    relation = relation.joins(:author).where("authors.name like :name", name: "%#{params[:author_name]}%").distinct if params[:author_name].present?
    relation = relation.where(classification: params[:classification]) if params[:classification].present?

    relation
  end

  def filter_order(relation)
    relation = relation.order("#{params[:sort]} desc") if params[:sort].present?
    relation
  end

  def count_change(attr_name, operation)
    sql = "update books set #{attr_name}_count = collection_count #{operation} 1 where id = #{@book.id}"
    ActiveRecord::Base.connection.execute(sql)
  end
end
