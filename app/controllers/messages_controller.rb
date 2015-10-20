class MessagesController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_conversation only: [:create, :show]

  def create
    @conversation = Conversation.find(params[:conversation_id])
    #@user = @conversation.recipient
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
    @path = conversation_path(@conversation)
    if @message.message_attachment_id
      redirect_to :back
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id)
  end
end
