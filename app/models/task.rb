class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"
  validates :assigner_id, presence: true
  validates :executor_id, presence: true
  validates :content, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :uncompleted, -> { where(completed_at: nil) }

  def completed?
    !completed_at.blank?
  end
end
