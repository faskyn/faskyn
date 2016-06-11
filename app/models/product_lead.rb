class ProductLead < ActiveRecord::Base
  belongs_to :product, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :lead, presence: { message: "can't be blank" }, length: { maximum: 80, message: "can't be longer than %{count} characters" }
  validates :pitch, presence: { message: "can't be blank" }
  validates :product, presence: true

  before_validation :format_lead_website
  validate :lead_website_validator

  def owner
    product.owner
  end

  private

    # def format_lead_website
    #   if website == ""
    #     self.website = nil
    #   else
    #     unless website.nil? || self.website[/^https?/]
    #       self.website = "http://#{self.website}"
    #     end
    #   end
    # end

    def format_lead_website
      if website == ""
        self.website = nil
      elsif website.present? && !self.website[/^https?/]
        self.website = "http://#{self.website}"
      end
    end

    def lead_website_validator
      unless website.nil?
        self.errors.add :website, "format is invalid!" unless website_valid?
      end
    end

    def website_valid?
      #!!website.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-=\?]*)*\/?$/)
      !!website.match(/\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i)
    end
end