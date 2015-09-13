class Task < ActiveRecord::Base
  belongs_to :assigner, class_name: "User"
  belongs_to :executor, class_name: "User"
  validates :assigner_id, presence: true
  validates :executor_id, presence: true
end
