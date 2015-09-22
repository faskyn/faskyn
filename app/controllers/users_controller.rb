class UsersController < ApplicationController
  include ApplicationHelper
  
  def index
    #if has_profile?
    @users = User.all
    respond_to do |format|
      format.html
      format.js
    end
    #end
  end

  def show
    @user = User.find(params[:id])
  end
end
