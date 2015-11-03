class TasknamecompaniesController < ApplicationController
  def index
    #@executors = User.joins(:profile).where("first_name LIKE ? OR last_name LIKE ? OR company LIKE ?", "%#{params[:term]}", "%#{params[:term]}", "%#{params[:term]}").all
    @executors = User.joins(:profile).where("first_name LIKE ? OR last_name LIKE ? OR company LIKE ?", "%#{params[:term].camelize}%", "%#{params[:term].camelize}%", "%#{params[:term].camelize}%").all 
    render json: @executors.pluck(:first_name, :last_name, :company).map{|e| e.join(' ')}
    #render json: %w[foo food four]
  end
end

private

def user_params
  params.require(:user).permit(:term)
end