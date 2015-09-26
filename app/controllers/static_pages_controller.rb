class StaticPagesController < ApplicationController
  #layout :static_pages_layout

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

  private

  def static_pages_layout
    "staticpages"
  end
end
