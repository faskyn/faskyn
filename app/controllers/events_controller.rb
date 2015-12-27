class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user_events_check, only: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
    @event = Event.new
    @events = Event.allevents(current_user)#.between_time(params[:start], params[:end]) if (params[:start] && params[:end])
    respond_to do |format|
      format.html
      format.json { render json: @events }
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @event }
    end
  end

  def new
    @user = current_user
    @event = Event.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @event = Event.new(event_params)
    @event.sender_id = current_user.id
    @event.start_at = DateTime.strptime(params[:event][:start_at], '%m/%d/%Y %I:%M %p').to_datetime.utc
    @event.end_at = DateTime.strptime(params[:event][:end_at], '%m/%d/%Y %I:%M %p').to_datetime.utc
    respond_to do |format|
      if @event.save
        format.html { redirect_to user_event_path(current_user, @event), :notice => 'Event was successfully created.' }
        format.json { render :json => @event, :status => :created, :location => @event }
        format.js
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @event }
    end
  end

  def update
    respond_to do |format|
      if @event.update_attributes(event_params)
        #format.html { redirect_to user_event_path(current_user, @event) }
        format.json { head :no_content }
      else
        #format.html { render action: "edit" }
        format.json { render json: { errormessages: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to user_events_path(current_user) }
      format.json { head :no_content }
    end
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:recipient_id, :sender_id, :title, :description, :start_at, :end_at, :all_day, :event_name_company, :start, :end)
    end

    def only_current_user_events_check
      @user = User.find(params[:user_id])
      unless @user == current_user
        redirect_to user_events_path(current_user), notice: "You can only check your own event page."
      end
    end
end
