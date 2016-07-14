class ProductLead < ActiveRecord::Base
  include Concerns::Validateable
  include Concerns::Commentable
  include Concerns::Notifiable

  belongs_to :product, touch: true

  validates :lead, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than %{count} characters" }
  validates :pitch, presence: { message: "can't be blank" }
  validates :product, presence: true
  validates :website, format: { with: WEBSITE_REGEX, message: "format is invalid" }, allow_nil: true

  def owner
    product.owner
  end
end