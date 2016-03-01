class StaticPagesController < ApplicationController
  layout "staticpages"

  def home
    expires_in 24.hours, :public => true
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
