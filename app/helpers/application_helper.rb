module ApplicationHelper
  def have_author_authority?(book)
    if current_user
      book.author == current_author || current_user.admin?
    else
      false
    end
  end
end
