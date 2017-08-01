class Api::V1::HomeController < Api::V1::BaseController
  skip_before_action :authenticate!

  def index
    unless params[:book_type].to_s.in? %w(0 1)
      params[:book_type] = nil
    end

    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).
        order("(click_count/book_chapters_count) desc").page(params[:page])

    books = @books.map do |book|
      {
          id: book.id,
          title: book.title,
          introduction: book.introduction,
          classification_name: book.classification.try(:name).to_s

      }
    end

    render_json_data({books: books})
  end
end
