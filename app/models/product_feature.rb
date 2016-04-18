class ProductFeature < ActiveRecord::Base
  belongs_to :product

  validates :feature, presence: { message: "can't be blank" }

  validates :product, presence: true
end
