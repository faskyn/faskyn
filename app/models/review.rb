class Review < ActiveRecord::Base
  belongs_to :product_customer, touch: true
  belongs_to :user

  validates :product_customer, presence: true
  validates :user, presence: true
  validates :body, presence: true, length: { maximum: 1000, message: "can't be longer than %{count} characters" }
end