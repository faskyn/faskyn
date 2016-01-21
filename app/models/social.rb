class Social < ActiveRecord::Base
  belongs_to :profile

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
