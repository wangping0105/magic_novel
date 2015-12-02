class BookChapter < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  belongs_to :book_volume, counter_cache: true

  has_many :book_marks, dependent: :destroy

  validates_presence_of :content, message:'内容不能为空!'
  validates_presence_of :title, message:'标题不能为空!'
  validates :title, uniqueness:{ scope: [:deleted_at, :book_id], message:'标题不能重复!', case_sensitive: false}

  def next_chapter
    BookChapter.where("id = ?", self.next_chapter_id).first
  end

  def prev_chapter
    BookChapter.where("id = ?", self.prev_chapter_id).first
  end
end
