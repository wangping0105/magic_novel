class Book < ActiveRecord::Base
  require 'ruby-pinyin'
  has_many :tags, through: :book_tag_relations
  has_many :book_chapters, dependent: :destroy
  has_many :book_volumes, dependent: :destroy
  has_many :book_marks, dependent: :destroy

  belongs_to :author, counter_cache: true
  belongs_to :classification, counter_cache: true

  acts_as_enum :book_types, :in => [ ['custom', 0, '原创'], ['reprint', 1, '转载'] ]
  acts_as_enum :status, :in => [ ['unline', 0, '未上线'], ['online', 1, '连载'], ['over', 2, '完本'] ]

  def chapter_of_book_mark_by(user)
    book_mark = book_marks.find_by(user_id: user.id)
    book_mark.present? ? book_mark.book_chapter: nil
  end
  # 软删除
  acts_as_paranoid

  after_initialize do
    self.pinyin = PinYin.of_string(self.title).join("")
  end

  validates :title, uniqueness:{ scope: [:deleted_at], message:'书籍已经存在!', case_sensitive: false}  #case_sensitive区分大小写
end
