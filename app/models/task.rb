class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"
  validates :assigner_id, presence: true
  validates :task_name_company, presence: { message: "must be an existing user" }
  validates :content, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :uncompleted, -> { where(completed_at: nil) }
  scope :alltasks, -> (u) { where('executor_id = ? OR assigner_id = ?', u.id, u.id) }
  scope :between, -> (assigner_id, executor_id) do
    where("(tasks.assigner_id = ? AND tasks.executor_id = ?) OR (tasks.assigner_id = ? AND tasks.executor_id = ?)", assigner_id, executor_id, executor_id, assigner_id)
  end

  #self.per_page = 12

  def completed?
    !completed_at.blank?
  end

  def task_name_company
    [executor.try(:profile).try(:first_name), executor.try(:profile).try(:last_name), executor.try(:profile).try(:company)].join(' ')
  end

  def task_name_company=(name)
    self.executor = User.joins(:profile).where("first_name LIKE ? OR last_name LIKE ? OR company LIKE ?", name, name, name).first
      #OR last_name = ? OR company = ?", split_task_name_company[0], split_task_name_company[1], split_task_name_company[2])
  end

=begin
  def indextasks
    indextasks = []
    indextasks << @assigned_tasks.uncompleted
    indextasks << @expired_tasks.uncompleted
    indextasks.sort_by { |h| h[:created_at] }.reverse!
  end
=end
end
