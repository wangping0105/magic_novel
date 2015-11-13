class BookVolume < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  has_many :book_chapters
end
