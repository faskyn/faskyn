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

  #chat notification gets checked
  def check_chat_notification
    if self.checked_at == nil
      update_attributes(checked_at: Time.zone.now)
    end
  end

  #other notification gets checked
  def check_other_notification
    if self.checked_at == nil
      update_attributes(checked_at: Time.zone.now)
    end
  end

  #checking if needed to decrease chat notification number
  def self.decreasing_chat_notification_number(current_user, user)
    if self.between_chat_recipient(current_user, user).unchecked.any?
      self.between_chat_recipient(current_user, user).last.check_chat_notification
      current_user.decrease_new_chat_notifications
      current_user.decreased_chat_number_pusher
    end
  end

  #checking if needed to decrease other notification number
  def self.decreasing_other_notification_number(current_user, user)
    if self.between_other_recipient(current_user, user)
      self.between_other_recipient(current_user, user).find_each do |notification|
        notification.check_other_notification
        current_user.decrease_new_other_notifications
        current_user.decreased_other_number_pusher
      end
    end
  end

end
