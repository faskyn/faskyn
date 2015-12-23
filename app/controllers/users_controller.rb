class UsersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:index, :show]
  before_action :set_conversation, only: [:show]
  
  def index
    @q_users = User.ransack(params[:q])
    #it's in the appliaction controller!!:@q = User.ransack(params[:q])
    #@users = @q_users.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 15)
    @users = @q_users.result(distinct: true).joins(:profile).preload(:profile).order(created_at: :desc).paginate(page: params[:page], per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    #set in application controller
  end
end
