Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret, 
    { :authorize_params => {
      :use_authorize => 'true'
      }
    }
end