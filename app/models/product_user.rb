class ProductUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :product, touch: true

  #before_destroy :check_for_owner

  validates :product, presence: true
  validates :user, presence: true
  validates :role, presence: true

  def check_for_owner
    if role == "owner"
      errors[:base] << "Owner can't be deleted!"
      return false
    end
  end
end