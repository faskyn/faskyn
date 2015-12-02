class Notification < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validates :notification_type, presence: true
  
  def self.send_notification(receiver, type, sender)
    #creating new notification record and updating notification number
    #chat is separated from the rest --> other group for the rest(only task at the moment)
    receiver.notifications.create(notification_type: type, sender: sender)
    #sending real-time notification count to other users via websocket
    if type == "chat"
      receiver.update_new_chat_notifications
      number = receiver.new_chat_notification
      Pusher['private-'+ receiver.id.to_s].trigger('new_chat_notification', {:number => number})
    else
      receiver.update_new_other_notifications
      number = receiver.new_other_notification
      Pusher['private-'+ receiver.id.to_s].trigger('new_other_notification', {:number => number})
    end      
  end
end
