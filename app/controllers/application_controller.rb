class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :if_profile_exists

  before_filter :set_search

  def if_profile_exists
    if @user.profile(current_user)
      redirect_to edit_user_profile_path(current_user)
    end
  end

  def has_profile_controller?
    current_user.profile.present?
  end

  def set_search
    @q = User.ransack(params[:q])
    @users3 = @q.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 3)
  end

end
