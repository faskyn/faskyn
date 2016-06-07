class ProductCustomer < ActiveRecord::Base
  belongs_to :product, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  has_many :users, through: :product_customer_users, source: :user
  has_many :product_customer_users
  has_many :group_invitations, as: :group_invitable, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :customer, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than %{count} characters" }
  validates :usage, presence: { message: "can't be blank" }
  validates :website, presence: { message: "can't be blank" }

  validates :product, presence: true

  before_validation :format_website
  validate :website_validator

  def owner
    product.owner
  end

  def user?(user)
    users.include?(user)
  end

  private

    def format_website
      unless website.nil? || self.website[/^https?/]
       self.website = "http://#{self.website}"
      end
    end

    def website_validator
      unless website.nil?
        self.errors.add :website, "format is invalid!" unless website_valid?
      end
    end

    def website_valid?
      !!website.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-=\?]*)*\/?$/)
    end

end