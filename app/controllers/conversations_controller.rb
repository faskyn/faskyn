class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  #layout false


#conversation creation in conversation model/task controller

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    render json: { conversation_id: @conversation.id }
  end


  def show
    #show action in application controller as set_conversation
    #@conversation = Conversation.find(params[:id])
    #@reciever = interlocutor(@conversation)
    #@messages = @conversation.messages
    #@message = Message.new
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
