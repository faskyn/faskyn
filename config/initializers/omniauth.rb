Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], 
    { :authorize_params => {
      :use_authorize => 'true'
      }
    }
  provider :linkedin, ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_API_SECRET']
  provider :angellist, Rails.application.secrets.angellist_api_key, Rails.application.secrets.angellist_api_secret
end

OmniAuth.config.on_failure = -> (env) do
  Rack::Response.new(['302 Moved'], 302, 'Location' => env['omniauth.origin'] || "/").finish
end



