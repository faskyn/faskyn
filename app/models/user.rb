class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :profile, dependent: :destroy
  delegate :first_name, to: :profile, allow_nil: true

  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy
  has_many :assigned_and_executed_tasks, -> (user) { where('executor_id = ? OR assigner_id = ?', user.id, user.id) }, class_name: 'Task', source: :task

  has_many :conversations, foreign_key: "sender_id", dependent: :destroy

  has_many :messages, dependent: :destroy

  def tasks_uncompleted
    tasks_uncompleted = assigned_tasks.uncompleted.order("deadline DESC")
    tasks_uncompleted += executed_tasks.uncompleted.order("deadline DESC")
    tasks_uncompleted.sort_by { |h| h[:deadline] }.reverse!
  end

   def tasks_completed
    tasks_completed = assigned_tasks.completed.order("created_at DESC")
    tasks_completed += executed_tasks.completed.order("created_at DESC")
    tasks_completed.sort_by { |h| h[:completed_at] }.reverse!
  end
end
