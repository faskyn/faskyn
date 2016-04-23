class IndustryProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :industry

  #validates_presence_of :product, presence: { message: "can't be blank" }
  validates_presence_of :industry, presence: { message: "can't be blank" }
end
