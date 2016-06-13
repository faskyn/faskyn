class ProductCustomer < ActiveRecord::Base
  WEBSITE_REGEX = /\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i
  include Concerns::Validatable

  belongs_to :product, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  has_many :users, through: :product_customer_users, source: :user
  has_many :product_customer_users, dependent: :destroy
  has_many :group_invitations, as: :group_invitable, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :customer, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than %{count} characters" }
  validates :usage, presence: { message: "can't be blank" }
  validates :website, presence: { message: "can't be blank" }, format: { with: WEBSITE_REGEX, message: "format is invalid" }
  validates :product, presence: true

  before_validation :format_website
  #validate :website_validator

  def owner
    product.owner
  end

  def user?(user)
    users.include?(user)
  end
end