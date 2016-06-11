class Product < ActiveRecord::Base
  require 'uri'
  include ActionView::Helpers::TextHelper
  mount_uploader :product_image, ProductImageUploader

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :users, through: :product_users
  has_many :product_users, dependent: :destroy
  has_many :owners, -> { where(product_users: { role: "owner" }) }, through: :product_users, source: :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy
  
  has_many :industry_products, dependent: :destroy, inverse_of: :product
  has_many :industries, through: :industry_products
  has_many :product_customers, dependent: :destroy, inverse_of: :product
  has_many :product_customer_users, through: :product_customers
  has_many :product_leads, dependent: :destroy, inverse_of: :product

  has_many :group_invitations, as: :group_invitable, dependent: :destroy

  accepts_nested_attributes_for :industry_products, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_customers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_leads, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than %{count} characters" }, uniqueness: { message: "already exists" }
  validates :website, presence: { message: "can't be blank" }
  validates :oneliner, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than %{count} characters" }
  validates :description, length: { maximum: 500, message: "can't be longer than %{count} characters"}

  validates_associated :industry_products
  validates_associated :product_customers
  validates_associated :product_leads

  validate :product_industries_limit
  validate :product_customers_limit_max
  validate :product_leads_limit_max
  validate :product_customer_and_lead_limit_min

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
      #!!website.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-=\?]*)*\/?$/)
      !!website.match(/\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i)
    end

    def product_industries_limit(max: 5, min: 1)
      if industries.reject(&:marked_for_destruction?).size > max
        errors.add :base, "You can't choose more than #{pluralize(max, 'industry')}."
      elsif industries.reject(&:marked_for_destruction?).size < min
        errors.add :base, "You have to choose at least #{pluralize(min, 'industry')}."
      end
    end

    def product_customers_limit_max(max: 5)
      if product_customers.reject(&:marked_for_destruction?).size > max
        errors.add :base, "You can't add more than #{pluralize(max, 'customer')}."
      end
    end

    def product_leads_limit_max(max: 5)
      if product_leads.reject(&:marked_for_destruction?).size > max
        errors.add :base, "You can't add more than #{pluralize(max, 'potential lead')}."
      end
    end

    def product_customer_and_lead_limit_min(min: 1)
      added_customer_count = product_customers.reject(&:marked_for_destruction?).size
      added_lead_count = product_leads.reject(&:marked_for_destruction?).size
      added_customer_and_lead_count = added_customer_count + added_lead_count 
      if added_customer_and_lead_count < min
        errors.add :base, "You have to add at least #{pluralize(min, 'current or potential customer')}."
      end
    end
end
