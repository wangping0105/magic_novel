class Author < ActiveRecord::Base
  has_many :books
  has_one :user


  def is_author_of?(book)
    if book
      book.author_id = id
    else
      false
    end
  end
end
