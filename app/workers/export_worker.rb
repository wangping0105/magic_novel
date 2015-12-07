class ExportWorker
  include Sidekiq::Worker

  def perform(opts = {})
    @books = Book.all
    if opts.present?
      @books = filter_page(@books, opts)
      @books = filter_params(@books, opts)
      @books = filter_order(@books, opts)
    end
    CsvExport.book_csv(@books)
  # rescue => e
  #   p "error"
  # ensure
  end

  private
  def filter_page(relation, opts = {})
    relation = relation.page(opts['page']).per(opts['per_page'])
    relation
  end

  def filter_params(relation, opts = {})
    relation = relation.where("title like :title or pinyin like :title ", title: "%#{opts['title']}%") if opts['title'].present?
    relation = relation.joins(:author).where("authors.name like :name", name: "%#{opts['author_name']}%").distinct if opts['author_name'].present?
    relation = relation.where(classification: opts['classification']) if opts['classification'].present?

    relation
  end

  def filter_order(relation, opts = {})
    relation = relation.order("#{opts['sort']} desc") if opts['sort'].present?
    relation
  end

end