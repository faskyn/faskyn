class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :if_profile_exists

  def if_profile_exists
    if @user.profile(current_user)
      redirect_to edit_user_profile_path(current_user)
    end
  end

end
