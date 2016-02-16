class IndustryProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :industry
end
