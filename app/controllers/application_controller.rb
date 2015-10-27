class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :if_profile_exists
  helper_method :if_no_profile_exists
  helper_method :other_user_profile_exists
  helper_method :if_tasks_any

  before_action :set_search

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

  def other_user_profile_exists
    @task = Task.new(task_params)
    unless @task.executor && @task.executor.profile
      flash[:warning] = "Executor hasn't created a profile yet."
      redirect_to user_tasks_path(current_user)
    end
  end

  def set_search
    @q = User.ransack(params[:q])
    @users3 = @q.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 3)
  end

  def set_conversation
    @user = User.find(params[:id])
    if Task.between(current_user.id, @user.id).present?
      @tasks = Task.uncompleted.between(current_user.id, @user.id).order("created_at DESC").paginate(page: params[:page], per_page: 12)
      @task = Task.new
      @task_between = Task.new
      if Conversation.between(current_user.id, @user.id).present?
        @conversation = Conversation.between(current_user.id, @user.id).first
        @reciever = interlocutor(@conversation)
        @messages = @conversation.messages
        @message = Message.new
        respond_to do |format|
          format.html
          format.js { render :template => "tasks/update.js.erb", :template => "tasks/destroy.js.erb", layout: false }
        end
      end
    else
      redirect_to user_profile_path(@user)
    end
  end

  private

  #def conversation_params
    #params.permit(:sender_id, :recipient_id)
  #end

  def interlocutor(conversation)
    current_user == conversation.recipient ? conversation.sender : conversation.recipient
  end

  def message_params
    params.require(:message).permit(:body, :message_attachment, :message_attachment_id, :message_attachment_cache_id)
  end

end
