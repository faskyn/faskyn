class Industry < ActiveRecord::Base
  has_many :industry_products, dependent: :destroy
  has_many :products, through: :industry_products

  accepts_nested_attributes_for :industry_products

  validates :name, presence: { messsage: "can not be blank" }
end
