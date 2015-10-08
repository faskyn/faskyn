class UsersController < ApplicationController
  include ApplicationHelper

  before_action :set_conversation, only: [:show]
  
  def index
    #it's in the appliaction controller!!:@q = User.ransack(params[:q])
    @users = @q.result(distinct: true).includes(:profile).paginate(page: params[:page], per_page: 12)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    #@user = User.find(params[:id])
    #respond_to do |format|
      #format.html #{ redirect_to action: :show  }
      #format.json { render json: { conversation_id: @conversation.id } }
    #end
  end

  
end
