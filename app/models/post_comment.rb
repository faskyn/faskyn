class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_one :user_profile, through: :user, source: :profile
  has_many :comment_replies

  validates :body, presence: true
  scope :ordered, -> { order(updated_at: :desc) }
  scope :included, -> { includes(:user, :user_profile) }
end
