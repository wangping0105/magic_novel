class Tag < ActiveRecord::Base
  has_many :books, through: :book_tag_relations
end
