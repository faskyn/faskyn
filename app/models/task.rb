class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"

  has_one :assigner_profile, through: :assigner, source: :profile
  has_one :executor_profile, through: :executor, source: :profile
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :assigner, presence: true
  validates :executor, presence: { message: "must be valid"}

  validates :content, presence: { message: "can't be blank" }, length: { maximum: 140, message: "can't be longer than %{count} characters" }
  validate :completed_at_date_cannot_be_in_the_future

  scope :completed, -> { where.not(completed_at: nil) }
  scope :uncompleted, -> { where(completed_at: nil) }
  scope :alltasks, -> (u) { where('executor_id = ? OR assigner_id = ?', u.id, u.id) }
  scope :between, -> (assigner_id, executor_id) do
    where("(tasks.assigner_id = ? AND tasks.executor_id = ?) OR (tasks.assigner_id = ? AND tasks.executor_id = ?)", assigner_id, executor_id, executor_id, assigner_id)
  end

  #number of tasks to appear on different task index pages
  def self.pagination_per_page
    12
  end

  def self.ordered
    order("updated_at DESC")
  end

  def self.paginated(page: 1)
    paginate(page: page, per_page: self.pagination_per_page)
  end

  def self.included
    includes(:executor_profile, :assigner_profile)
  end

  def self.assigned_default(page: 1)
    uncompleted.included.ordered.paginated(page: page)
  end

  def self.executed_default(page: 1)
    uncompleted.included.ordered.paginated(page: page)
  end

  def self.completed_default(page: 1)
    completed.included.order(completed_at: :desc).paginated(page: page)
  end

  def self.index_default(page: 1)
    uncompleted.included.ordered.paginated(page: page)    
  end

  #getter setter method code for new task executor search/select/autocomplete
  def task_name_company
    [executor.try(:profile).try(:first_name), executor.try(:profile).try(:last_name), executor.try(:profile).try(:company)].join(' ')
  end

  def task_name_company=(name)
    self.executor = User.joins(:profile).where("CONCAT_WS(' ', first_name, last_name, company) LIKE ?", "%#{name}%").first if name.present?
  rescue ArgumentError
    self.executor = nil
  end
  #end of getter setter method for new task executor

  def completed?
    completed_at
  end

  private

    def completed_at_date_cannot_be_in_the_future
      errors.add(:completed_at, "can't be in the future") if
        completed_at.present? && completed_at > Time.zone.now
    end
end
