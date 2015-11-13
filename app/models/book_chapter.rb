class BookChapter < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  belongs_to :book_volume, counter_cache: true

  has_one :next_chapter, class_name: 'BookChapter', foreign_key: :next_chapter_id
  has_one :prev_chapter, class_name: 'BookChapter', foreign_key: :prev_chapter_id

end
