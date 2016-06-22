class UsersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:index, :show]
  
  def index
    @users = User.joins(:profile).preload(:profile).order(created_at: :desc).paginate(page: params[:page], per_page: 16)
    authorize @users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    if current_user == @user
      redirect_to user_profile_path(@user)
    else
      @conversation = Conversation.create_or_find_conversation(current_user.id, @user.id)
      @tasks = Task.uncompleted.between(current_user.id, @user.id).order("created_at DESC").includes(:assigner, :executor).paginate(page: params[:page], per_page: 14)
      #@conversation = Conversation.between(current_user.id, @user.id).first
      @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
      current_user.decreasing_chat_notification_number(@user)
      current_user.decreasing_task_notification_number(@user)
      respond_to do |format|
        format.html
        format.js { render template: "tasks/between.js.erb", layout: false }
      end
    end
  end

  private
end
