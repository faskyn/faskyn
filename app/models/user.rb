class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_one :profile, dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id"
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id"
end
