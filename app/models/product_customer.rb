class ProductCustomer < ActiveRecord::Base
  include Concerns::Validateable
  include Concerns::Commentable
  include Concerns::Notifiable

  belongs_to :product, touch: true

  has_many :users, through: :product_customer_users, source: :user
  has_many :product_customer_users, dependent: :destroy
  has_many :group_invitations, as: :group_invitable, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :customer, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than %{count} characters" }
  validates :usage, presence: { message: "can't be blank" }
  validates :website, presence: { message: "can't be blank" }, format: { with: WEBSITE_REGEX, message: "format is invalid" }
  validates :product, presence: true

  def owner
    product.owner
  end

  def user?(user)
    users.include?(user)
  end
end