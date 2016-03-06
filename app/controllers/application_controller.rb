class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :if_no_profile_exists
  helper_method :if_tasks_any?
  helper_method :only_current_user

  before_action :set_search

  def google7df1f819c8dc9008
  end

  def if_no_profile_exists
    unless @user.profile(current_user)
      flash[:warning] = "Please create a profile first!"
      redirect_to new_user_profile_path(current_user)
    end
  end

  def if_tasks_any?
    current_user.executed_tasks.any? || current_user.assigned_tasks.any?
  end

  def only_current_user
    @user = User.find(params[:user_id])
    #flash[:danger] = "You can't do this action!"
    #redirect_to user_tasks_path(current_user) unless @user == current_user
  end

  def set_search
    @q_users = User.ransack(params[:q])
    #regardless the search it gives back the users the current_user hast the most tasks with
    if user_signed_in?
      #@users3 = current_user.ordered_relating_users
      @users3 = @q_users.result(distinct: true).includes(:profile).limit(8)
    else
    # #displaying users in the sidebar not needed at the moment as it will appear in the main area
      @users3 = @q_users.result(distinct: true).includes(:profile).limit(8)#paginate(page: params[:page], per_page: 6)
    end
  end

  def set_conversation
    #NOT NEEDED AT THE MOMENT SINCE GOING TO THIS PAGE WILL TRIGGER TO CHECK ALL THE COMMON NOTS
    # if params[:update_check_at]
    #   @notification = Notification.find(params[:task_notification_id])
    #   @notification.update_attributes(checked_at: Time.zone.now)
    # end
    @user = User.find(params[:id])
    if Task.between(current_user.id, @user.id).present?
      @tasks = Task.uncompleted.between(current_user.id, @user.id).order("created_at DESC").includes(:assigner, :assigner_profile, :executor, :executor_profile).paginate(page: params[:page], per_page: 14)
      @task_between = Task.new
      @conversation = Conversation.create_or_find_conversation(current_user, @user)
      @messages = @conversation.messages.includes(:user).order(created_at: :desc).limit(50).reverse
      @message = Message.new
      Notification.decreasing_chat_notification_number(current_user, @user)
      Notification.decreasing_task_notification_number(current_user, @user)
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

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
