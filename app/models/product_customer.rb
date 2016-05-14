class ProductCustomer < ActiveRecord::Base
  belongs_to :product, touch: true

  validates :customer, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :usage, presence: { message: "can't be blank" }

  validates :product, presence: true
end