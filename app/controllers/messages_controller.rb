class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @receiver = interlocutor(@conversation)
    @message.link = check_if_link(@message.body) if @message.body?
    @message.save!
    @path = conversation_path(@conversation)
    #creating notification if all the prev chat notifications are checked
    if @message.save && (Notification.between_chat_recipient(@receiver, @message.user).unchecked.count < 1)
      Notification.send_notification(@receiver, "chat", @message.user)
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
