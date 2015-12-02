class BookMark < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :book_chapter
end
