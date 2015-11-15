module ApplicationHelper
  def have_author_authority?(book)
    book.author == current_author
  end
end
