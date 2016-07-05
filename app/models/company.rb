class Company < ActiveRecord::Base
  WEBSITE_REGEX = /\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i
  include Concerns::Validatable

  attachment :company_pitch_attachment, store: 'company_files_backend', extension: ["pdf"]

  belongs_to :product

  validates :name, presence: { message: "can't be blank" }
  validates :location, presence: { message: "can't be blank" }
  validates :founded, presence: { message: "can't be blank" }
  validates :team_size, presence: { message: "can't be blank" }, numericality: { only_integer: true, message: "must be an integer" }
  validates :engineer_number, presence: { message: "can't be blank" }, numericality: { only_integer: true, message: "must be an integer" }
  validates :revenue_type, presence: { message: "can't be blank" }
  validates :revenue, presence: { message: "can't be blank" }
  validates :website, presence: { message: "can't be blank" }
  validates :investment, numericality: { only_integer: true, message: "must be an integer" }

  validate :team_size_greater_than_engineer_number
  validate :founded_in_the_past
  validate :investor_investment_relation
  validate :revenue_type_revenue_relation

  before_validation :format_investment
  before_validation :format_website

  def format_investment
    if investment.blank? || investment < 0
      self.investment = 0
    end
  end

  def revenue_type_revenue_relation
    if revenue_type == "no revenue" && revenue != "$0"
      errors.add :base, 'If you choose no revenue as revenue type then revenue must be $0'
    end
  end

  def investor_investment_relation
    if investment == 0 && investor.present?
      errors.add :base, "Investment can't be 0 when investor is given"
    elsif investment > 0 && investor.blank?
      errors.add :base, "Investor can't be blank when investment is greater than 0"
    end
  end 

  def team_size_greater_than_engineer_number
    if (engineer_number && team_size) && engineer_number > team_size
      errors.add :base, "Number of engineers can't be greater than team size."
    end
  end

  def founded_in_the_past
    if founded && (Date.new(founded.year, founded.month, 1) > Date.current)
      errors.add :base, "Founding date must be in the past."
    end
  end
end