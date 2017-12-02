class Book < ActiveRecord::Base
  require 'ruby-pinyin'
  has_many :tags, through: :book_tag_relations
  has_many :book_chapters, dependent: :destroy
  has_many :book_volumes, dependent: :destroy
  has_many :book_marks, dependent: :destroy

  belongs_to :operator, class_name: 'User', foreign_key: 'operator_id'
  belongs_to :author, counter_cache: true
  belongs_to :classification, counter_cache: true

  scope :book_type, ->(book_type){book_type.present? ? where(book_type: book_type): nil}
  scope :online_books, ->{where(status: [1, 2])}
  scope :unline_books, ->{where(status: 0)} # 这个基本不回用到
  scope :serial_books, ->{where(status: 1)}
  scope :over_books, ->{where(status: 2)}
  scope :pending_books, ->{where(status: 3)}

  acts_as_enum :book_types, :in => [ ['custom', 0, '原创'], ['reprint', 1, '转载'] ]
  acts_as_enum :status, :in => [ ['unline', 0, '未上线'], ['serial', 1, '连载'], ['over', 2, '完本'], ['pending', 3, '待审核'], ['failure', 4, '未通过'] ]
  # Book.statuses
  # 软删除
  acts_as_paranoid

  validates :title, uniqueness:{ scope: [:deleted_at], message:'书籍已经存在!', case_sensitive: false}  #case_sensitive区分大小写
  validates_presence_of :book_type, message:'类型不能为空!'

  after_initialize do
    self.pinyin = PinYin.of_string(self.title).join("") if self.title.present?
  end

  def chapter_of_book_mark_by(user)
    book_mark = book_marks.select{|m| m.user_id = user.id}.first

    unless book_mark.present?
      book_chapter = book_chapters.last
      book_mark = BookMark.create(book_chapter: book_chapter, user: user, book: self)
    end

    book_mark.book_chapter
  end

  def status_names
    Book.status_options.find{|a| a.second == status}.first
  rescue
    ""
  end

  def book_types_names
    Book.book_types_options.find{|a| a.second == book_type}.first
  rescue
    ""
  end

  def newest_chapter
    book_chapters.last
  end

  def newest_chapter_simple
    key = "newest_chapter_for_book_#{id}"
    Rails.cache.fetch(key, expires_in: 1.days) do
      book_chapters.last.slice(:id, :title)
    end
  end

  def as_json
    slice(:id, :title, :introduction)
  end
end
