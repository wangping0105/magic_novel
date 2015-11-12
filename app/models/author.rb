class Author < ActiveRecord::Base
  has_many :books
  has_one :user
end
