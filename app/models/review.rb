class Review < ActiveRecord::Base
  belongs_to :product_customer, touch: true
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :product_customer, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 1000, message: "can't be longer than %{count} characters" }

  def twitter_share_text(review, product_customer)
    TwitterReviewShare.new(review, product_customer).return_text
  end
end