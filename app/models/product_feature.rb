class ProductFeature < ActiveRecord::Base
  belongs_to :user

  validates :feature, presence: { message: "can not be blank" }
end
