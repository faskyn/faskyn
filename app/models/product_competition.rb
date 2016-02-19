class ProductCompetition < ActiveRecord::Base
  belongs_to :product

  validates :competitor, presence: { message: "can not be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :differentiator, presence: { message: "can not be blank" }
end
