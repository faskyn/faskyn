class Product < ActiveRecord::Base
  mount_uploader :product_image, ProductImageUploader

  belongs_to :user
  has_many :industry_products, dependent: :destroy, inverse_of: :product
  has_many :industries, through: :industry_products
  has_many :product_usecases, dependent: :destroy, inverse_of: :product

  accepts_nested_attributes_for :industry_products, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_usecases, reject_if: :all_blank, allow_destroy: true

  validates :user, presence: true

  validates :name, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }, uniqueness: { message: "already exists" }
  validates :website, presence: { message: "can't be blank" }
  validates :oneliner, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :description, length: { maximum: 500, message: "can't be longer than 500 characters"}

  validates_associated :industry_products
  validates_associated :product_usecases

  validate :product_industries_limit
  validate :product_usecases_limit

  before_validation :format_website
  validate :website_validator

  def self.pagination_per_page
    12
  end

  def industries_all
    industry_array = []
    self.industries.each do |industry|
      industry_array << industry.name
    end
    industry_array.join(", ")
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

    # def website_valid?
    #   url = URI.parse(website) rescue false
    #   url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
    # end

    # def website_validator
    #   self.errors.add :website, "format is invalid!" unless website_valid?  
    # end

    def product_industries_limit
      if self.industries.reject(&:marked_for_destruction?).count > 5
        self.errors.add :base, "You can't choose more than 5 industries."
      elsif self.industries.reject(&:marked_for_destruction?).blank?
        self.errors.add :base, "You have to choose at least 1 industry."
      end
    end

    def product_usecases_limit
      if self.product_usecases.reject(&:marked_for_destruction?).count > 10
        self.errors.add :base, "You can't have more than 10 usecases."
      elsif self.product_usecases.reject(&:marked_for_destruction?).count < 1
        self.errors.add :base, "You must describe at least 1 usecase."
      end
    end
end
