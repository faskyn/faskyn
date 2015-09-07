class UsersController < ApplicationController
  
  def index
    @users = User.all
    @profile = @users.profile
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
