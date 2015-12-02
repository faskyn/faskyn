class MessagesController < ApplicationController
  before_action :authenticate_user!
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.js? }

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @receiver = interlocutor(@conversation)
    @message.save!
    @path = conversation_path(@conversation)
    if @message.save
      #sender_full_name = full_name_for_notifications_from_message(@receiver)
      Notification.send_notification(@receiver, "chat", @message.user.profile.first_name)
      #Pusher['private-'+ @conversation.sender_id.to_s].trigger('new_chat_notification', {:from => current_user.profile.first_name, :body => @message.body})
    end
  end

  private

    def interlocutor(conversation)
      current_user == conversation.recipient ? conversation.sender : conversation.recipient
    end

    def message_params
      params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id, :remove_message_attachment)
    end
end
