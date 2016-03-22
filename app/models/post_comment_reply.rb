class PostCommentReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_comment

  has_one :user_profile, through: :user, source: :profile

  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  scope :included, -> { includes(:user, :user_profile) }
  scope :ordered, -> { order(updated_at: :asc) }
end
