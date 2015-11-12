class BookChapter < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  belongs_to :book_volumn, counter_cache: true
end
