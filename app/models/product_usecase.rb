class ProductUsecase < ActiveRecord::Base
  belongs_to :product

  validates :example, presence: { message: "can not be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :detail, presence: { message: "can not be blank" }
end
