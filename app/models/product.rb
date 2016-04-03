class Product < ActiveRecord::Base
  mount_uploader :product_image, ProductImageUploader

  belongs_to :user
  has_many :industry_products, dependent: :destroy, inverse_of: :product
  has_many :industries, through: :industry_products
  has_many :product_features, dependent: :destroy
  has_many :product_competitions, dependent: :destroy
  has_many :product_usecases, dependent: :destroy

  accepts_nested_attributes_for :industry_products, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_features, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_competitions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_usecases, reject_if: :all_blank, allow_destroy: true

  validates :user, presence: true

  validates :name, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }, uniqueness: { message: "already exists" }
  validates :company, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :website, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :oneliner, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validates :description, presence: { message: "can not be blank" }, length: {maximum: 500, message: "can't be longer than 500 characters"}

  validates_associated :industry_products
  validates_associated :product_features
  validates_associated :product_competitions
  validates_associated :product_usecases

  validate :product_industries_limit
  validate :product_features_limit
  validate :product_competitions_limit
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
      self.website = "http://#{self.website}" unless self.website[/^https?/]
    end

    def website_validator
      self.errors.add :website, "format is invalid!" unless website_valid?
    end

    def website_valid?
      !!website.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-=\?]*)*\/?$/)
    end

    def product_industries_limit
      if self.industries.reject(&:marked_for_destruction?).count > 5
        self.errors.add :base, "You can't choose more than 5 industries."
      elsif self.industries.reject(&:marked_for_destruction?).blank?
        self.errors.add :base, "You have to choose at least 1 industry."
      end
    end

    def product_features_limit
      if self.product_features.reject(&:marked_for_destruction?).count > 10
        self.errors.add :base, "You can't have more than 10 features."
      elsif self.product_features.reject(&:marked_for_destruction?).count < 1
        self.errors.add :base, "You must have at least 1 product feature."
      end
    end

    def product_competitions_limit
      if self.product_competitions.reject(&:marked_for_destruction?).count > 10
        self.errors.add :base, "You can't have more than 10 competitions."
      elsif self.product_competitions.reject(&:marked_for_destruction?).count < 1
        self.errors.add :base, "You must name at least 1 competition."
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
