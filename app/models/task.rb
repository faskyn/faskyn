class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"
  validates :assigner_id, presence: true
  validates :executor_id, presence: true
  validates :content, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :uncompleted, -> { where(completed_at: nil) }
  scope :alltasks, -> (u) { where('executor_id = ? OR assigner_id = ?', u.id, u.id) }

  def completed?
    !completed_at.blank?
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
