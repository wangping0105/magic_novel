class BooksController < ApplicationController
  before_action :set_book, only: [:show, :destroy, :collection, :uncollection]
#  before_action :authenticate_user!
  def index
    @books = Book.all
    @books = filter_page(@books)
    @books = filter_params(@books)
    @books = filter_order(@books)
    @classifications = Classification.all.map{|c| [c.name, c.id]}

    respond_to do |format|
      format.html
    end
  end

  def new
    @book = Book.new
    @classifications = Classification.all.map{|c| [c.name, c.id]}
  end

  def show
    @book_chapters = @book.book_chapters.includes(:book_volume).order(book_volume_id: :asc).order(id: :asc).page(params[:page]).per(32)
    # @book_volumns = @book.book_volumes.includes(:book_chapters)
    @collection = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation.relation_type_options.select{|a| a[0]=='收藏'}[0][1])
  end

  def create
    _params_book =  params_book.merge(author_id: current_author.id)
    if params_book['book_type'].to_i == 1
      author = Author.find_or_create_by(name: params[:author_name])
      _params_book[:author_id] = author.id
      _params_book[:operator_id] = current_user.id
    end
    @book = Book.new(_params_book)

    raise_error(params[:author_name].blank? , "作者名不能为空！")
    if @book.save
      tags = params[:tag_names].split(";")
      tags.each {|t| BookTagRelation.create(tag: t, book: @book) }
      flash[:success] = "创建成功"
      redirect_to books_path
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

  def collection
    BookRelation.find_or_create_by(book: @book, user: current_user, relation_type: BookRelation.relation_type_options.select{|a| a[0]=='收藏'}[0][1])
    flash[:success] = "添加收藏成功"
    redirect_to book_path(@book)
  end

  def uncollection
    @collection = BookRelation.find_by(book: @book, user: current_user, relation_type: BookRelation.relation_type_options.select{|a| a[0]=='收藏'}[0][1])
    @collection.destroy if @collection
    flash[:success] = "取消收藏成功"
    redirect_to book_path(@book)
  end

  def csv_export
    ExportWorker.perform_async(params)
    render json: {data:0}
  end
  # ======================================================================================
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
    relation = relation.where("title like :title or pinyin like :title ", title: "%#{params[:title]}%") if params[:title].present?
    relation = relation.joins(:author).where("authors.name like :name", name: "%#{params[:author_name]}%").distinct if params[:author_name].present?
    relation = relation.where(classification: params[:classification]) if params[:classification].present?

    relation
  end

  def filter_order(relation)
    relation = relation.order("#{params[:sort]} desc") if params[:sort].present?
    relation
  end
end