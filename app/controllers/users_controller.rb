class UsersController < ApplicationController
  include ApplicationHelper
  
  def index
    #it's in the appliaction controller!!:@q = User.ransack(params[:q])
    @users = @q.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 12)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
