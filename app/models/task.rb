class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"

  has_one :assigner_profile, through: :assigner, source: :profile
  has_one :executor_profile, through: :executor, source: :profile

  validates :assigner, presence: true
  validates :executor, presence: { message: "must be valid"}
  #validates :executor, exclusion: { in: "szaros", message: "%{value} doesn't exist" }
  validates :content, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }
  validate :deadline_date_cannot_be_in_the_past

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

  def completed?
    !completed_at.blank?
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

  private

    def deadline_date_cannot_be_in_the_past
      errors.add(:deadline, "can't be in the past") if
        !deadline.blank? and deadline < DateTime.now
    end
end
