class Social < ActiveRecord::Base
  belongs_to :profile

  #scope :current_user_social, -> (u) { joins(:profile).where('profile.user_id = ?', u.id) }

  # def self.init_google_api_calendar_client(google_account)
  #   #method only called if google_oauth2 social exists
  #   client = Google::APIClient.new
  #   client.authorization.access_token = google_account.token
  #   client.authorization.client_id = ENV['GOOGLE_API_KEY']
  #   client.authorization.client_secret = ENV['GOOGLE_API_SECRET']
  #   client.authorization.refresh_token = google_account.refresh_token
  #   return client
  # end

  # get '/' do
  # # Fetch list of events on the user's default calandar
  # events = calendar.list_events('primary', options: { authorization: user_credentials })
  # [200, {'Content-Type' => 'application/json'}, events.to_h.to_json] end


  # def posting_event
  #   service = client.discovered_api('calendar', 'v3')
  #   result = client.execute (
  #     api_method: service.calendar)
  # end

  def self.find_or_create_from_auth_hash(auth_hash)
    #checking if the connected account exists (one use can have one acc/provider at the moment)
    #for google api the goal is the connect the user's calendar to the google calendar not to update the profile
    social_acc = where(provider: auth_hash.provider).first_or_create
    if auth_hash.provider == "google_oauth2"
      social_acc.update(
        uid: auth_hash.uid,
        email: auth_hash.info.email,
        token: auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token,
        expires_at: Time.at(auth_hash.credentials.expires_at).to_datetime)
      social_acc
    else
      social_acc.update(
        #no first_name, last_name and phone for twitter
        uid: auth_hash.uid,
        token: auth_hash.credentials.token,
        secret: auth_hash.credentials.secret,
        picture_url: auth_hash.info.image,
        location: auth_hash.info.location,
        description: auth_hash.info.description,
        first_name: auth_hash.info.first_name || nil,
        last_name: auth_hash.info.last_name || nil,
        phone: auth_hash.info.phone || nil,
        page_url:   case social_acc.provider
                    when 'twitter' then auth_hash.info.urls.Twitter
                    when 'linkedin' then auth_hash.info.urls.public_profile
                    end
        )
      social_acc
    end
  end
end
