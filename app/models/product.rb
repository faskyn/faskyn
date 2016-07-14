class Product < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Concerns::Validateable
  include Concerns::Commentable
  include Concerns::Notifiable
  mount_uploader :product_image, ProductImageUploader

  delegate :name, to: :company, prefix: true, allow_nil: true

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :users, through: :product_users
  has_many :product_users, dependent: :destroy
  has_many :owners, -> { where(product_users: { role: "owner" }) }, through: :product_users, source: :user 
  has_one :company, dependent: :destroy
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
  validates :website, presence: { message: "can't be blank" }, format: { with: WEBSITE_REGEX, message: "format is invalid" }
  validates :oneliner, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than %{count} characters" }
  validates :description, length: { maximum: 500, message: "can't be longer than %{count} characters"}

  validates_associated :industry_products
  validates_associated :product_customers
  validates_associated :product_leads

  validate :product_industries_limit
  validate :product_customers_limit_max
  validate :product_leads_limit_max
  validate :product_customer_and_lead_limit_min

  def self.pagination_per_page
    8
  end

  def industries_all
    industry_array = []
    self.industries.each do |industry|
      industry_array << industry.name
    end
    industry_array.join(", ")
  end

  private

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
        errors.add :base, "You can't add more than #{pluralize(max, 'target customer')}."
      end
    end

    def product_customer_and_lead_limit_min(min: 1)
      added_customer_count = product_customers.reject(&:marked_for_destruction?).size
      added_lead_count = product_leads.reject(&:marked_for_destruction?).size
      added_customer_and_lead_count = added_customer_count + added_lead_count 
      if added_customer_and_lead_count < min
        errors.add :base, "You have to add at least #{pluralize(min, 'current or target customer')}."
      end
    end
end
