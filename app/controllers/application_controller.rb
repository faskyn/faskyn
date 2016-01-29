class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :if_profile_exists
  helper_method :if_no_profile_exists
  helper_method :if_tasks_any?
  helper_method :only_current_user

  before_action :set_search

  def google7df1f819c8dc9008
  end

  def if_profile_exists
    if @user.profile(current_user)
      redirect_to edit_user_profile_path(current_user)
    end
  end

  def if_no_profile_exists
    unless @user.profile(current_user)
      flash[:warning] = "Please create a profile first!"
      redirect_to new_user_profile_path(current_user)
    end
  end

  def has_profile_controller?
    current_user.profile.present?
  end

  def if_tasks_any?
    current_user.executed_tasks.any? || current_user.assigned_tasks.any?
  end

  # def other_user_profile_exists
  #   @task = Task.new(task_params)
  #   unless @task.executor && @task.executor.profile
  #     flash[:warning] = "Executor hasn't created a profile yet."
  #     redirect_to user_tasks_path(current_user)
  #   end
  # end

  def only_current_user
    @user = User.find(params[:user_id])
    redirect_to user_tasks_path(current_user) unless @user == current_user
  end

  def set_search
    @q_users = User.ransack(params[:q])
    #regardless the search it gives back the users the current_user hast the most tasks with
    if user_signed_in? #&& if_tasks_any?
      #@users3 = current_user.ordered_relating_users
      @users3 = @q_users.result(distinct: true).includes(:profile).limit(8)
    else
    # #displaying users in the sidebar not needed at the moment as it will appear in the main area
      @users3 = @q_users.result(distinct: true).includes(:profile).limit(8)#paginate(page: params[:page], per_page: 6)
    end
  end

  def set_conversation
    @user = User.find(params[:id])
    if Task.between(current_user.id, @user.id).present?
      @tasks = Task.uncompleted.between(current_user.id, @user.id).order("created_at DESC").includes(:assigner).paginate(page: params[:page], per_page: 14)
      @task_between = Task.new
      @conversation = Conversation.create_or_find_conversation(current_user, @user)
      @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
      @message = Message.new
      Notification.decreasing_chat_notification_number(current_user, @user)
      Notification.decreasing_other_notification_number(current_user, @user)
      respond_to do |format|
        format.html
        format.js { render :template => "tasks/between.js.erb", layout: false }
      end
    else
      redirect_to user_profile_path(@user)
    end
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
