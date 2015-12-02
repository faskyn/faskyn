class ConversationsController < ApplicationController
  before_action :authenticate_user!

  #conversation creation in conversation model/task controller
  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_path(@conversation)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @user = interlocutor(@conversation)
    @receiver = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
    @messages_with_file = @conversation.messages.with_file.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def index #listing chat notifications
    @conversations = Conversation.where("conversations.recipient_id = ? OR conversations.sender_id = ?", current_user, current_user)
    current_user.reset_new_chat_notifications
  end

  private

    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end

    def interlocutor(conversation)
      current_user == conversation.recipient ? conversation.sender : conversation.recipient
    end

    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to user_tasks_path(current_user) unless @user == current_user
    end
end
