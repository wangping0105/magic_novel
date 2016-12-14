class ChatRoom < ActiveRecord::Base
  belongs_to :book
  has_many :messages
end
