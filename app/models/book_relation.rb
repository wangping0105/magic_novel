class BookRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  COUNT_LIMT = 20

  acts_as_enum :relation_type, in: [['collection', 0, '收藏'], ['like', 1, '赞'], ['recommend', 2, '推荐']]

  validate :check_collection

  def check_collection
    if self.collection?
      count = COUNT_LIMT

      if BookRelation.where(relation_type: self.relation_type, user: self.user).count >= count
        errors.add("collection_limit", "#{count}")

        return
      end
    end
  end
end
