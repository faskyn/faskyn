class Notification < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :notifiable, polymorphic: true

  has_one :sender_profile, through: :sender, source: :profile
  has_one :recipient_profile, through: :recipient, source: :profile

  after_create :send_pusher_notification

  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true

  scope :not_chat, -> { where.not(notifiable_type: "Message") }
  scope :chat, -> { where(notifiable_type: "Message") }
  scope :task, -> { where(notifiable_type: "Task") }
  scope :post, -> { where(notifiable_type: "Post") }
  scope :checked, -> { where.not(checked_at: nil) }
  scope :unchecked, -> { where(checked_at: nil) }

  scope :this_post_comments, -> (recipient_id, post_id) do
    where("notifications.recipient_id = ? AND notifications.notifiable_id = ?", recipient_id, post_id)
  end

  scope :between_chat_recipient, -> (recipient_id, sender_id) do
    where("notifications.recipient_id = ? AND notifications.sender_id = ? AND notifications.notifiable_type = ?", recipient_id, sender_id, "Message")
  end

  scope :between_other_recipient, -> (recipient_id, sender_id) do
    where("notifications.recipient_id = ? AND notifications.sender_id = ? AND notifications.notifiable_type != ?", recipient_id, sender_id, "Message")
  end

  def self.pagination_per_page
    12
  end
  
  #check and decrease chat notification that happens between 2 given users (max 1)
  def self.decreasing_chat_notification_number(current_user, user)
    notification = self.between_chat_recipient(current_user, user).unchecked.first
    notification.checking_and_decreasing_notification(current_user) if notification.present?
  end

  #check and decrease task notifications that happens between 2 given users
  def self.decreasing_task_notification_number(current_user, user)
    self.task.between_other_recipient(current_user, user).unchecked.each do |notification|
      notification.checking_and_decreasing_notification(current_user)
    end
  end

  #check and decrease the post notification that belongs to a given post
  def self.decreasing_post_notification_number(current_user, post_id)
    self.this_post_comments(current_user, post_id).unchecked.each do |notification|
      notification.checking_and_decreasing_notification(current_user)
    end
  end

  def checking_and_decreasing_notification(current_user)
    self.check_notification
    if self.notifiable_type == "Message"
      current_user.decrease_new_chat_notifications
      current_user.decreased_chat_number_pusher
    else
      current_user.decrease_new_other_notifications
      current_user.decreased_other_number_pusher
    end
  end

  def check_notification #chat notification gets checked
    update_attribute(:checked_at, Time.zone.now) if self.checked_at.nil?
  end

  def send_pusher_notification
    if self.notifiable_type == "Message"
      self.recipient.increase_new_chat_notifications
      number = self.recipient.new_chat_notification
      Pusher['private-'+ self.recipient_id.to_s].trigger('new_chat_notification', {:number => number})
    else
      self.recipient.increase_new_other_notifications
      number = self.recipient.new_other_notification
      Pusher['private-'+ self.recipient_id.to_s].trigger('new_other_notification', {:number => number})
    end      
  end

  private

    
end
