class StaticPagesController < ApplicationController
  layout "staticpages"

  def home
    if user_signed_in? 
      if has_profile_controller?
        redirect_to user_tasks_path(current_user)
      else
        redirect_to users_path
      end
    end
  end

  def about
  end

  def help
  end

  def privacypolicy
  end

end
