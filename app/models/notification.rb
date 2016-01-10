class Notification < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validates :notification_type, presence: true

  scope :not_chat, -> { where.not(checked_at: nil) }
  scope :chat, -> { where(notification_type: "chat") }
  scope :checked, -> { where.not(checked_at: nil) }
  scope :unchecked, -> { where(checked_at: nil) }
  scope :between_chat_recipient, -> (recipient_id, sender_id) do
    where("notifications.recipient_id = ? AND notifications.sender_id = ? AND notifications.notification_type = ?", recipient_id, sender_id, "chat")
  end
  scope :between_other_recipient, -> (recipient_id, sender_id) do
    where("notifications.recipient_id = ? AND notifications.sender_id = ? AND notifications.notification_type != ?", recipient_id, sender_id, "chat")
  end

  def self.pagination_per_page
    8
  end
  
  def self.send_notification(receiver, type, sender)
    #creating new notification record and updating notification number
    #chat is separated from the rest --> other group for the rest(only task at the moment)
    receiver.notifications.create(notification_type: type, sender: sender)
    #sending real-time notification count to other users via websocket
    if type == "chat"
      receiver.increase_new_chat_notifications
      number = receiver.new_chat_notification
      Pusher['private-'+ receiver.id.to_s].trigger('new_chat_notification', {:number => number})
    else
      receiver.increase_new_other_notifications
      number = receiver.new_other_notification
      Pusher['private-'+ receiver.id.to_s].trigger('new_other_notification', {:number => number})
    end      
  end

  #used when user gets to the showpage of the sender not when gets to the notfication page
  def check_chat_notification
    if self.checked_at == nil
      update_attributes(checked_at: Time.now)
    end
  end

  #used when seen on the notifications page
  def check_other_notification
    if self.checked_at == nil
      update_attributes(checked_at: Time.now)
    end
  end
end
