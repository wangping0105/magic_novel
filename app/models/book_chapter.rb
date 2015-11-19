class BookChapter < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  belongs_to :book_volume, counter_cache: true

  has_one :next_chapter, class_name: 'BookChapter', foreign_key: :next_chapter_id
  has_one :prev_chapter, class_name: 'BookChapter', foreign_key: :prev_chapter_id

  validates_presence_of :content, message:'内容不能为空!'
  validates_presence_of :title, message:'标题不能为空!'
  validates :title, uniqueness:{ scope: [:deleted_at, :book_id], message:'标题不能重复!', case_sensitive: false}
end
