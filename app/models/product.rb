class Product < ActiveRecord::Base
  belongs_to :user
  has_many :industry_products, dependent: :destroy
  has_many :industries, through: :industry_products
  has_many :product_features

  accepts_nested_attributes_for :industry_products, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_features, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :company, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :website, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :oneliner, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :description, presence: { message: "can not be blank" }
  validates :usecase, presence: { message: "can not be blank" }
  validates :competition, presence: { message: "can not be blank" }

  validates_associated :industry_products
  validates_associated :product_features

  def industries_all
    industry_array = []
    self.industries.each do |industry|
      industry_array << industry.name 
    end
    industry_array.join(", ")
  end
end
