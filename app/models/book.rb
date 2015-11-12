class Book < ActiveRecord::Base
  has_many :tags, through: :book_tag_relations
  has_many :book_chapters
  has_many :book_volumes

  belongs_to :author
  belongs_to :classification, polymorphic: true
  acts_as_enum :book_types, :in => [ ['custom', 0, '原创'], ['reprint', 1, '转载'] ]
end
