class PostComment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :comment_replies

  validates :body, presence: true
end
