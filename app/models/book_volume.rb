class BookVolume < ActiveRecord::Base
  belongs_to :book, counter_cache: true
end
