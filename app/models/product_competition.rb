class ProductCompetition < ActiveRecord::Base
  belongs_to :product

  validates :competitor, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :differentiator, presence: { message: "can't be blank" }

  validates :product, presence: true
end
