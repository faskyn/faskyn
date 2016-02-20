class StaticPagesController < ApplicationController
  layout "staticpages"

  def home
    if user_signed_in? 
      redirect_to products_path
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
