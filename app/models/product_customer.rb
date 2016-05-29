class ProductCustomer < ActiveRecord::Base
  belongs_to :product, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  validates :customer, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than 80 characters" }
  validates :usage, presence: { message: "can't be blank" }
  #validates :website, presence: { message: "can't be blank" }

  validates :product, presence: true

  before_validation :format_website
  validate :website_validator

  def owner
    product.owner
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