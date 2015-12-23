class EventnamecompaniesController < ApplicationController
  def index
    @recipients = User.joins(:profile).where("first_name LIKE ? OR last_name LIKE ? OR company LIKE ?", "%#{params[:term].camelize}%", "%#{params[:term].camelize}%", "%#{params[:term].camelize}%").all 
    render json: @recipients.pluck(:first_name, :last_name, :company).map{|e| e.join(' ')}
  end

  private

    def user_params
      params.require(:user).permit(:term)
    end

end