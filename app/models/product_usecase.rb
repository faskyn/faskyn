class ProductUsecase < ActiveRecord::Base
  belongs_to :product, touch: true

  validates :example, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :detail, presence: { message: "can't be blank" }

  validates :product, presence: true
end
