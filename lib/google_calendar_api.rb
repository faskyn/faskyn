module GoogleCalendarApi

  def init_google_api_calendar_client(google_account)
    #method only called if google_oauth2 social exists
    client = Google::APIClient.new
    client.authorization.access_token = google_account.token
    client.authorization.client_id = ENV['GOOGLE_API_KEY']
    client.authorization.client_secret = ENV['GOOGLE_API_SECRET']
    client.authorization.refresh_token = google_account.refresh_token
    return client
  end

  def get_busy_events(social_object)
    client = init_google_api_calendar_client(social_object)
    old_token = client.authorization.access_token
    service = client.discovered_api('calendar', 'v3')

    result_raw = client.execute(
      :api_method => service.freebusy.query,
      :body => JSON.dump({ 
              :timeMin => '2015-12-24T17:06:02.000Z',
              :timeMax => '2016-01-30T17:06:02.000Z',
              :items => [{ :id => social_object.email }]}),
      :headers => {'Content-Type' => 'application/json'})

     
    new_token = client.authorization.access_token
    if old_token != new_token
      social_object.update_attribute(:token, new_token)
    end

    result = JSON.parse(result_raw.body)['calendars'][social_object.email]['busy'] || []
    
    formatted_result = result.each do |event| 
      event['title'] = 'busy'
      event['editable'] = false
    end

    return formatted_result
  end

  
  # def open_gcal_connection(options, initialized_client, social_object)
  #   client = initialized_client
  #   old_token = client.authorization.access_token
  #   service = client.discovered_api('calendar', 'v3')
  #   result = client.execute(options) #after execution you may get new token

  #   # update token if the token that was sent back is expired
  #   new_token = client.authorization.access_token
  #   if old_token != new_token
  #     social_object.update_attribute(token: new_token)
  #   end
  #   return result
  # end

  # def get_calendars
  #   result = open_gcal_connection(
  #     {:api_method => service.calendar_list.list,
  #     :parameters => {},
  #     :headers => {'Content-Type' => 'application/json'}
  #     })
  #   #handling results
  # end

  # def get_busy_events
  #   result = open_gcal_connection(
  #     api_method: service.freebusy.query,
  #     body: JSON.dump({ timeMin: '2015-12-24T17:06:02.000Z',
  #                      timeMax: '2013-12-31T17:06:02.000Z',
  #                      items: social_object.email }),
  #     headers: {'Content-Type' => 'application/json'})
  #   #handling results
  # end
end










