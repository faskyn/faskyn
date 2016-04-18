class PostCommentReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_comment, touch: true
  has_one :user_profile, through: :user, source: :profile

  validates :post_comment, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(updated_at: :asc) }
end
