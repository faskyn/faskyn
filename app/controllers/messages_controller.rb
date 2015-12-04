class MessagesController < ApplicationController
  before_action :authenticate_user!
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.js? }

  def create
    #creating chat message
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @receiver = interlocutor(@conversation)
    @message.save!
    @path = conversation_path(@conversation)
    #creating notification if all the prev chat notifications are checked
    if @message.save && (Notification.between_chat_recipient(@receiver, @message.user).unchecked.count < 1)
      Notification.send_notification(@receiver, "chat", @message.user)
    end
    # if @message.save && @message.body
    #   update_attributes(@message.body = "")
    # end
    # if @message.save && (Notification.between_chat_recipient(@message.user, @receiver).unchecked.count == 1)
    #   @message.user.decrease_new_chat_notifications
    # end
  end

  private

    def interlocutor(conversation)
      current_user == conversation.recipient ? conversation.sender : conversation.recipient
    end

    def message_params
      params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id, :remove_message_attachment)
    end

    def notification_params
      params.require(:notification).permit(:recipient_id, :sender_id, :notification_type, :checked_at)
    end
end
