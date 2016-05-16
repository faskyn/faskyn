class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, presence: true
  validates :new_chat_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :new_other_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  delegate :first_name, :last_name, :full_name, :job_title, :company, :phone_number, :description, :location, :avatar, to: :profile, allow_nil: true

  has_one :profile, dependent: :destroy
  has_many :socials, dependent: :destroy, through: :profile

  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy

  has_many :conversations, foreign_key: "sender_id", dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy

  has_many :products, dependent: :nullify

  has_many :posts
  has_many :comments
  has_many :comment_replies, through: :comments

  
  #check and decrease chat notification that happens between 2 given users (max 1)
  def decreasing_chat_notification_number(user)
    notification = notifications.between_chat_recipient(user).unchecked.first
    checking_and_decreasing_notification(notification) if notification.present?
  end

  #check and decrease task notifications that happens between 2 given users
  def decreasing_task_notification_number(user)
    notifications.task.between_other_recipient(user).unchecked.each do |notification|
      checking_and_decreasing_notification(notification)
    end
  end

  #check and decrease the post notification that belongs to a given post
  def decreasing_post_notification_number(post_id)
    notifications.this_post_comments(post_id).unchecked.each do |notification|
      checking_and_decreasing_notification(notification)
    end
  end

  # def decreasing_product_notification_number(product_id)
  #   notifications.this_product_comments(product_id).unchecked.each do |notification|
  #     checking_and_decreasing_notification(notification)
  #   end
  # end

  def checking_and_decreasing_notification(notification)
    notification.check_notification
    if notification.notifiable_type == "Message"
      decrease_new_chat_notifications
      decreased_chat_number_pusher
    else
      decrease_new_other_notifications
      decreased_other_number_pusher
    end
  end

  #counting notifications for user
  def increase_new_chat_notifications
    increment!(:new_chat_notification)
  end

  def decrease_new_chat_notifications
    decrement!(:new_chat_notification) if new_chat_notification > 0
  end

  def reset_new_chat_notifications
    update_attributes(new_chat_notification: 0)
  end

  def increase_new_other_notifications
    increment!(:new_other_notification)
  end

  def decrease_new_other_notifications
    decrement!(:new_other_notification) if new_other_notification > 0
  end

  def reset_new_other_notifications
    update_attributes(new_other_notification: 0)
  end

  def decreased_chat_number_pusher(number = new_chat_notification)
    Pusher.trigger_async('private-'+ id.to_s, 'new_chat_notification', { number: number })
  end

  def decreased_other_number_pusher( number = new_other_notification)
    Pusher.trigger_async('private-'+ id.to_s, 'new_other_notification', { number: number })
  end
end
