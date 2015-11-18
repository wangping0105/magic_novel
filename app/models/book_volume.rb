class BookVolume < ActiveRecord::Base
  belongs_to :book, counter_cache: true
  has_many :book_chapters, dependent: :destroy

  has_one :next_volume, class_name: 'BookVolume', foreign_key: :prev_volume_id
  has_one :prev_volume, class_name: 'BookVolume', foreign_key: :next_volume_id
end
