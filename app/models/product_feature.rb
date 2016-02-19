class ProductFeature < ActiveRecord::Base
  belongs_to :product

  validates :feature, presence: { message: "can not be blank" }
end
