class RequestLog < ApplicationRecord

  belongs_to :user
  belongs_to :book_chapter, foreign_key: :last_chapter_id

  def time_diff_in(t: 30.minutes)
    Time.now - self.created_at <= t
  end
end
