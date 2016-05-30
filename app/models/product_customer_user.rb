class ProductCustomerUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :product_customer, touch: true

  validates :user, presence: true
  validates :product_customer, presence: true
end