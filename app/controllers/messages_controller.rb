class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user = current_user
    @receiver = interlocutor(@conversation)
    @receiver_id = @receiver.id
    @message.link = check_if_link(@message.body) if @message.body?
    #@message.save!
    if @message.save
      current_user.decreasing_chat_notification_number(@receiver)
      if (@receiver.notifications.between_chat_recipient(current_user).unchecked.count < 1)
        #Notification.send_notification(@receiver, "chat", @message.user)
        Notification.create(recipient_id: @receiver.id, sender_id: current_user.id, notifiable: @message, action: "sent")
      end
      respond_to :js
    end 
  end

  private

    def interlocutor(conversation)
      current_user == conversation.recipient ? conversation.sender : conversation.recipient
    end

    def check_if_link(message)
      regexp = /(https?:\/\/(?:www\.|(?!www))[^\s\.]+\.[^\s]{2,}|www\.[^\s]+\.[^\s]{2,})/
      message.scan(regexp).present? ? message.scan(regexp) : nil
    end

    def message_params
      params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id, :remove_message_attachment, :link)
    end
end
