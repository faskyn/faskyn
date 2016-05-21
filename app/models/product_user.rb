class ProductUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :product, touch: true

  validates :product, presence: true
  validates :user, presence: true
  validates :role, presence: true
end