class SocialsController < ApplicationController
  before_action :authenticate_user!

  def create
    #render text: request.env['omniauth.auth'].to_yaml
    # raise :test
    #when user clicks on button to authorize the given social site
    #user's permission for calendar is asked here as well
    begin
      @profile = current_user.profile
      @social = @profile.socials.find_or_create_from_auth_hash(auth_hash)
      if auth_hash.provider == "google_oauth2"
        flash[:success] = "Your faskyn calendar is now connected to your google calendar!"
      else  
        flash[:success] = "#{@social.provider.camelize} account was successfully updated!"
      end
    rescue
      flash[:warning] = "There was an error while trying to authenticate you!"
    end
    redirect_to edit_user_profile_path(current_user)
  end

  def update
  end

  def create2
    # #What data comes back from OmniAuth?
    # @auth = request.env["omniauth.auth"]
    # #Use the token from the data to request a list of calendars
    # @token = @auth["credentials"]["token"]
    # client = Google::APIClient.new 
    # client.authorization.access_token = @token
    # service = client.discovered_api('calendar', 'v3')
    # @result = client.execute( :api_method => service.calendar_list.list, :parameters => {}, :headers => {'Content-Type' => 'application/json'})
    # #SECOND VERSION
    # client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    # service = Google::Apis::CalendarV3::CalendarService.new
    # service.authorization = client
    # @calendar_list = service.list_calendar_lists
    # #THIRD VERSION
    # @set_event = client.execute(:api_method => service.events.insert,
    #                     :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
    #                     :body => JSON.dump(@event),
    #                     :headers => {'Content-Type' => 'application/json'})
  end

  def destroy
  end

  private

    def social_params
      params.require(:social).permit(:provider, :uid, :token, :secret, :first_name, :last_name, :page_url, :picture_url, :location, :description, :phone, :email, :refresh_token, :expires_at)
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
