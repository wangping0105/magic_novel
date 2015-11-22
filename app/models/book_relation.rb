class BookRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  acts_as_enum relation_type: [['collection', 0, '收藏'], ['like', 1, '赞'], ['recommend', 2, '推荐']]
end
