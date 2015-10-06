class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :profile, dependent: :destroy

  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy

  has_many :conversations, foreign_key: "sender_id", dependent: :destroy

  has_many :messages, dependent: :destroy

=begin
  def tasks
    tasks = []
    tasks << @assigned_tasks
    tasks << @expired_tasks
    tasks.sort_by { |h| h[:created_at] }.reverse!
  end

  
  def indextasks
    Task.find_by_sql ["SELECT tasks.* FROM tasks WHERE  assigner_id = ? OR executor_id = ? order by created_at DESC", self.id, self.id]
  end
=end
  def tasks_uncompleted
    tasks_uncompleted = assigned_tasks.uncompleted.order("created_at DESC")
    tasks_uncompleted += executed_tasks.uncompleted.order("created_at DESC")
    tasks_uncompleted.sort_by { |h| h[:created_at] }.reverse!
  end

   def tasks_completed
    tasks_completed = assigned_tasks.completed.order("created_at DESC")
    tasks_completed += executed_tasks.completed.order("created_at DESC")
    tasks_completed.sort_by { |h| h[:completed_at] }.reverse!
  end


end
