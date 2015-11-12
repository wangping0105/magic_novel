class BookChapter < ActiveRecord::Base
  belongs_to :book, polymorphic: true
end
