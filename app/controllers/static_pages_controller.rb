class StaticPagesController < ApplicationController
  layout "staticpages"

  def home
    if user_signed_in? 
      if has_profile_controller?
        redirect_to user_tasks_path(current_user)
      else
        redirect_to users_path
      end
    else
      expires_in 24.hours, :public => true
    end
  end

  def about
    expires_in 24.hours, :public => true
  end

  def help
    expires_in 24.hours, :public => true
  end

  def privacypolicy
    expires_in 24.hours, :public => true
  end

end
