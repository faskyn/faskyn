class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :notification_type, presence: true

  #to call send_notification -> Notification.send_notification(other_user, "request", self.name)
  
  def self.send_notification(receiver, type, sender_name)
    #creating new notification record and updating notification number
    #chat is separated from the rest --> other group for the rest(only task at the moment)
    receiver.notifications.create(notification_type: type, sender: sender_name)
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
