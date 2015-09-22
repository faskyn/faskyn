class StaticPagesController < ApplicationController
  #layout :static_pages_layout
  def home
    if user_signed_in?
      redirect_to users_path
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
