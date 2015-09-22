class StaticPagesController < ApplicationController
  #layout :static_pages_layout
  def home
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
