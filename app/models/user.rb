class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, presence: true
  validates :new_chat_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :new_other_notification, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  delegate :first_name, :last_name, :full_name, :job_title, :company, :phone_number, :description, :location, :avatar, :avatar_url, to: :profile, allow_nil: true

  has_one :profile, dependent: :destroy
  has_many :socials, through: :profile

  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy
  has_many :executed_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy

  has_many :conversations, foreign_key: "sender_id", dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: "recipient_id", dependent: :destroy

  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy

  has_many :created_products, class_name: "Product", foreign_key: "user_id", dependent: :destroy
  has_many :product_users, dependent: :destroy
  has_many :products, through: :product_users
  #has_many :own_products, -> { where(product_users: { role: "owner" }) }, through: :product_users, source: :product

  has_many :product_customer_users, dependent: :destroy

  #has_many :sent_group_invitations, foreign_key: "sender_id", dependent: : destroy
  has_many :group_invitations, foreign_key: "recipient_id", dependent: :destroy
  has_many :sent_group_invitations, class_name: "GroupInvitation", foreign_key: "sender_id", dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_replies, through: :comments, dependent: :destroy
  
  #check and decrease chat notification that happens between 2 given users (max 1)
  def decreasing_chat_notification_number(sender)
    notification = notifications.between_chat_recipient(sender).unchecked.first
    checking_and_decreasing_notification(notification) if notification.present?
  end

  #check and decrease task notifications that happens between 2 given users
  def decreasing_task_notification_number(sender)
    notifications.task.between_other_recipient(sender).unchecked.each do |notification|
      checking_and_decreasing_notification(notification)
    end
  end

  #check and decrease the comment notification that belongs to a given notifiable
  # def decreasing_comment_notification_number(notifiable_type, notifiable_id)
  #   notifications.this_notifiable(notifiable_type, notifiable_id).unchecked.each do |notification|
  #     checking_and_decreasing_notification(notification)
  #   end
  # end
  def decreasing_other_notification_number(noti)
    notifications.this_notifiable(noti.notifiable_type, noti.notifiable_id).unchecked.each do |notification|
      checking_and_decreasing_notification(notification)
    end
  end

  def checking_and_decreasing_notification(notification)
    notification.check_notification
    if notification.notifiable_type == "Message"
      decrease_new_chat_notifications
      chat_notification_number_to_pusher
    else
      decrease_new_other_notifications
      other_notification_number_to_pusher
    end
  end

  def decrease_new_chat_notifications
    decrement!(:new_chat_notification) if new_chat_notification > 0
  end

  def reset_new_chat_notifications
    update_attributes(new_chat_notification: 0)
  end

  def decrease_new_other_notifications
    decrement!(:new_other_notification) if new_other_notification > 0
  end

  def reset_new_other_notifications
    update_attributes(new_other_notification: 0)
  end

  def chat_notification_number_to_pusher
    Pusher.trigger_async('private-'+ id.to_s, 'new_chat_notification', { number: new_chat_notification })
  end

  def other_notification_number_to_pusher
    Pusher.trigger_async('private-'+ id.to_s, 'new_other_notification', { number: new_other_notification })
  end

  def is_invited_or_member?(group_invitable)
    if (group_invitable.users.where("user_id = ?", self.id).any? || 
      group_invitable.group_invitations.where("recipient_id = ?", self.id).any?)
      true
    else
      false
    end
  end
end
