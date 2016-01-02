OmniAuth.config.full_host = Rails.env.production? ? 'http://appfaskyn.herokuapp.com' : 'http://localhost:3000'
#certification_google = Rails.env.production? ? { ca_file: '/usr/lib/ssl/certs/ca-certificates.crt'} : { :verify => !Rails.env.development? }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], 
    { :authorize_params => {
      :use_authorize => 'true'
      }
    }
  provider :linkedin, ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_API_SECRET']
  provider :google_oauth2, ENV['GOOGLE_API_KEY'], ENV['GOOGLE_API_SECRET'], {
    scope: 'email calendar',
    access_type: 'offline'
    #ssl: certification_google
  }
end

OmniAuth.config.on_failure = -> (env) do
  Rack::Response.new(['302 Moved'], 302, 'Location' => env['omniauth.origin'] || "/").finish
end

#Rails.env.production? ? ca_file: '/usr/lib/ssl/certs/ca-certificates.crt' : ca_path: '/etc/ssl/certs'

