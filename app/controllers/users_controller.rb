class UsersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:index, :show]
  
  def index
    @q_users = User.ransack(params[:q])
    #it's in the appliaction controller!!:@q = User.ransack(params[:q])
    #@users = @q_users.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 15)
    @users = @q_users.result(distinct: true).joins(:profile).preload(:profile).order(created_at: :desc).paginate(page: params[:page], per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
    if Task.between(current_user.id, @user.id).present?
      @tasks = Task.uncompleted.between(current_user.id, @user.id).order("created_at DESC").includes(:assigner, :executor).paginate(page: params[:page], per_page: 14)
      @task_between = Task.new
      @conversation = Conversation.between(current_user.id, @user.id).first
      @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
      @message = Message.new
      current_user.decreasing_chat_notification_number(@user)
      current_user.decreasing_task_notification_number(@user)
      respond_to do |format|
        format.html
        format.js { render template: "tasks/between.js.erb", layout: false }
      end
    else
      redirect_to user_profile_path(@user)
    end
  end

  private
end
