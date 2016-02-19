if Rails.env.production?
  Rack::Timeout.timeout = 20 
end