class Rack::Attack

  Rack::Attack.throttled_response = lambda do |env|
    retry_after = (env['rack.attack.match_data'] || {})[10]
    # if env['rack.attack.content_type'] == 'text/html'
    #[429, {'Retry-After' => retry_after.to_s}, [ActionView::Base.new.render(file: 'public/429.html', content_type: 'text/html')]]
    # elsif env['rack.attack.content_type'] == 'application/javascript'
    #   [429, {'Retry-After' => retry_after.to_s}, window.location.href = '/429.html']
    # end
    #puts env
    [429, {'Retry-After' => retry_after.to_s}, [ActionView::Base.new.render(file: 'public/429.html', content_type: 'text/html')]]
    # if env["HTTP_X_REQUESTED_WITH"] && env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    #   [429, {'Retry-After' => retry_after.to_s}, [window.location.href = '/429.html', content_type: 'application/javascript']]
    # else
    #   [429, {'Retry-After' => retry_after.to_s}, [ActionView::Base.new.render(file: 'public/429.html', content_type: 'text/html')]]
    # end
    # body = [
    #   env['rack.attack.matched'],
    #   env['rack.attack.match_type'],
    #   env['rack.attack.match_data'],
    #   env['rack.attack.match_discriminator']
    #   #Rack::Attack.instrument(req)
    # ].inspect
    # puts body
    # [ 503, {}, [body]]
  end

  #sending notification to airbrake (also set on airbrake site)
  if Rails.env.production?
    ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
      Airbrake.notify Exception.new(message: "#{req.ip} has been rate limited for url #{req.url}", data: [name, start, finish, request_id, req])
    end
  end

  # Rack::Attack.whitelist('allow from localhost') do |req|
  #   '127.0.0.1' == req.ip || '::1' == req.ip
  # end

  #basic action limit (this should be the least strict)
  Rack::Attack.throttle('req_ip', :limit => 40, period: 10.seconds) do |req|
    req.ip unless req.path.starts_with?('/assets')
  end

  #against email login attacks
  Rack::Attack.throttle('logins_email', limit: 5, period: 30.seconds) do |req|
    req.params['email'].presence if req.path == '/users/sign_in' && req.post?
  end
end

#rest of the limited actions are defined in the YAML file
@rack_attack_config = YAML.load_file('config/rack_attack.yml').with_indifferent_access

def from_config(key, field)
  @rack_attack_config[key][field] || @rack_attack_config[:default][field]
end

@rack_attack_config.keys.each do |key|
  Rack::Attack.throttle(key, limit: from_config(key, :limit), period: from_config(key, :period)) do |req|
    req.ip if req.path.ends_with?(from_config(key, :path).to_s) && from_config(key, :method) == req.env['REQUEST_METHOD']
    #/#{from_config(key, :path)}/.match(req.path.to_s)
  end
end