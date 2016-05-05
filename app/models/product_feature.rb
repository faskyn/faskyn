class ProductFeature < ActiveRecord::Base
  belongs_to :product, touch: true

  validates :feature, presence: { message: "can't be blank" }

  validates :product, presence: true
end
