class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, presence: true
  validates :new_chat_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :new_other_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_one :profile, dependent: :destroy
  has_many :socials, dependent: :destroy, through: :profile
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy
  has_many :assigned_and_executed_tasks, -> (user) { where('executor_id = ? OR assigner_id = ?', user.id, user.id) }, class_name: 'Task', source: :task

  has_many :conversations, foreign_key: "sender_id", dependent: :destroy

  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy

  has_many :events, foreign_key: "recipient_id", dependent: :destroy

  has_many :messages, dependent: :destroy

  has_many :products, dependent: :nullify

  has_many :posts
  has_many :post_comments, through: :posts

  delegate :first_name, :last_name, :full_name, :company, :job_title, :phone_number, :description, :location, :avatar, to: :profile, allow_nil: true
  
  #check and decrease chat notification that happens between 2 given users (max 1)
  def decreasing_chat_notification_number(user)
    notification = self.notifications.between_chat_recipient(user).unchecked.first
    self.checking_and_decreasing_notification(notification) if notification.present?
  end

  #check and decrease task notifications that happens between 2 given users
  def decreasing_task_notification_number(user)
    self.notifications.task.between_other_recipient(user).unchecked.each do |notification|
      self.checking_and_decreasing_notification(notification)
    end
  end

  #check and decrease the post notification that belongs to a given post
  def decreasing_post_notification_number(post_id)
    self.notifications.this_post_comments(post_id).unchecked.each do |notification|
      self.checking_and_decreasing_notification(notification)
    end
  end

  def checking_and_decreasing_notification(notification)
    notification.check_notification
    if notification.notifiable_type == "Message"
      self.decrease_new_chat_notifications
      self.decreased_chat_number_pusher
    else
      self.decrease_new_other_notifications
      self.decreased_other_number_pusher
    end
  end

  #counting notifications for user
  def increase_new_chat_notifications
    increment!(:new_chat_notification)
  end

  def decrease_new_chat_notifications
    decrement!(:new_chat_notification) if self.new_chat_notification > 0
  end

  def reset_new_chat_notifications
    update_attributes(new_chat_notification: 0)
  end

  def increase_new_other_notifications
    increment!(:new_other_notification)
  end

  def decrease_new_other_notifications
    decrement!(:new_other_notification) if self.new_other_notification > 0
  end

  def reset_new_other_notifications
    update_attributes(new_other_notification: 0)
  end

  def decreased_chat_number_pusher
    number = self.new_chat_notification
    Pusher['private-'+ self.id.to_s].trigger('new_chat_notification', {:number => number})
  end

  def decreased_other_number_pusher
    number = self.new_other_notification
    Pusher['private-'+ self.id.to_s].trigger('new_other_notification', {:number => number})
  end
end
