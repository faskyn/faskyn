class NotificationSender
  attr_reader :notification, :recipient

  def initialize(notification)
    @notification = notification
    @recipient = notification.recipient
  end

  def send_increased
    if notification.notifiable_type == "Message"
      increase_new_chat_notifications
      chat_notification_number_to_pusher
    else
      increase_new_other_notifications
      other_notification_number_to_pusher
    end      
  end

  private

    def increase_new_chat_notifications
      recipient.increment!(:new_chat_notification)
    end

    def increase_new_other_notifications
      recipient.increment!(:new_other_notification)
    end

    def chat_notification_number_to_pusher
      Pusher.trigger_async('private-'+ recipient.id.to_s, 'new_chat_notification', { number: recipient.new_chat_notification })
    end

    def other_notification_number_to_pusher
      Pusher.trigger_async('private-'+ recipient.id.to_s, 'new_other_notification', { number: recipient.new_other_notification })
    end
end