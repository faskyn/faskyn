class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_one :profile, dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id"
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id"

=begin
  def tasks
    tasks = []
    tasks << @assigned_tasks
    tasks << @expired_tasks
    tasks.sort_by { |h| h[:created_at] }.reverse!
  end
=end
  
  def tasks
    Task.find_by_sql ["SELECT tasks.* FROM tasks WHERE  assigner_id = ? OR executor_id = ? order by created_at DESC", self.id, self.id]
  end

end
