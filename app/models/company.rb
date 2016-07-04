class Company < ActiveRecord::Base
  belongs_to :product

  validates :name, presence: { message: "can't be blank" }
  validates :location, presence: { message: "can't be blank" }
  validates :founded, presence: { message: "can't be blank" }
  validates :team_size, presence: { message: "can't be blank" }, numericality: { only_integer: true, message: "must be an integer" }
  validates :engineer_number, presence: { message: "can't be blank" }, numericality: { only_integer: true, message: "must be an integer" }
  validates :revenue_type, presence: { message: "can't be blank" }
  validates :revenue, presence: { message: "can't be blank" }
  validates :investment, numericality: { only_integer: true, message: "must be an integer" }

  validate :team_size_greater_than_engineer_number
  validate :founded_in_the_past
  validate :investor_investment_relation
  validate :revenue_type_revenue_relation

  before_validation :format_investment

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