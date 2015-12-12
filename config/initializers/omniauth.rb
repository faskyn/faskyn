Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret, 
    { :authorize_params => {
      :use_authorize => 'true'
      }
    }
  provider :linkedin, Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_api_secret
  provider :angellist, Rails.application.secrets.angellist_api_key, Rails.application.secrets.angellist_api_secret
end

OmniAuth.config.on_failure = -> (env) do
  Rack::Response.new(['302 Moved'], 302, 'Location' => env['omniauth.origin'] || "/").finish
end



