class EventsController < ApplicationController
  include GoogleCalendarApi #lib/google_calendar_api.rb
  #all the data comes from google API --> no model

  before_action :authenticate_user!

  def index
    @current_user = current_user
    @param_id = request.parameters['user_id']
    @user = User.find(@param_id)
    @google = @user.socials.where(provider: "google_oauth2").first
    if @google.present? && (@user == @current_user || Task.between(@current_user.id, @user.id).present?)
      if params['start'] && params['end']
        @start_time = params['start'].to_datetime.rfc3339
        @end_time = params['end'].to_datetime.rfc3339
        @timezone = params['timezoneParam']
        if @user == @current_user
          @results = get_own_events(@google, @start_time, @end_time, @timezone)
        else
          @results = get_busy_events(@google, @start_time, @end_time)
        end
      end
      #@results = get_own_events(@google, "2015-12-27T00:00:00+00:00", "2016-02-27T00:00:00+00:00")
      #@results_busy = get_busy_events(@google, "2015-12-27T00:00:00+00:00", "2016-02-27T00:00:00+00:00")
      respond_to do |format|
        format.html
        format.json { render json: @results }
      end
    elsif @google.blank? && (@user == @current_user || Task.between(@current_user.id, @user.id).present?)
      respond_to do |format|
        format.html
      end
    elsif @user.profile.present?
      begin
        redirect_to :back, notice: "You and #{@user.profile.full_name} have no common tasks yet!"
      rescue
        redirect_to root_path(@current_user), notice: "You and #{@user.profile.full_name} have no common tasks yet!"
      end
    else
      begin
        redirect_to :back, notice: "The user who you are looking for hasn't created a profile yet!"
      rescue
        redirect_to root_path(@current_user), notice: "The user who you are looking for hasn't created a profile yet!"
      end
    end
  end

  private

    def event_params
      params.require(:event).permit(:recipient_id, :sender_id, :title, :description, :start_at, :end_at, :all_day, :event_name_company, :start, :end)
      params.permit('start', 'end', :start, :end)
    end

    def only_current_user_events_check
      @user = User.find(params[:user_id])
      unless @user == current_user
        redirect_to user_events_path(current_user), notice: "You can only check your own event page."
      end
    end
end
