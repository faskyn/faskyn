class MessagesController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_conversation only: [:create, :show]
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.js? }

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id, :remove_message_attachment)
  end
end
