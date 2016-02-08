module GoogleCalendarApi
  #module included in events controller

  def init_google_api_calendar_client(google_account)
    #initializing new client (only called if google_oauth2 social exists)
    client = Google::APIClient.new
    client.authorization.access_token = google_account.token
    client.authorization.client_id = ENV['GOOGLE_API_KEY']
    client.authorization.client_secret = ENV['GOOGLE_API_SECRET']
    client.authorization.refresh_token = google_account.refresh_token
    return client
  end

  def get_busy_events(social_object, start_time, end_time, timezone)#start_time and end_time must be string
    #busy events get displayed when current user checks sby else's calendar aka events index page
    client = init_google_api_calendar_client(social_object)
    old_token = client.authorization.access_token
    service = client.discovered_api('calendar', 'v3')

    #API request/response
    result_raw = client.execute(
      :api_method => service.freebusy.query,
      :body => JSON.dump({ 
              :timeMin => start_time,
              :timeMax => end_time,
              :timeZone => timezone,
              :items => [{ :id => social_object.email }]}),
      :headers => {'Content-Type' => 'application/json'})

    #token refresh if needed
    new_token = client.authorization.access_token
    if old_token != new_token
      social_object.update_attribute(:token, new_token)
      get_busy_events(social_object,start_time, end_time, timezone)
    end

    #API response parsing
    result = JSON.parse(result_raw.body)['calendars'][social_object.email]['busy']
    
    #changing response to fullcalendar format
    formatted_event_array = []
    
    result.each do |event|
      start_time = event['start'].to_datetime.rfc822
      end_time = event['end'].to_datetime.rfc822
      formatted_event = {}
      formatted_event['title'] = 'busy'
      formatted_event['start'] = start_time
      formatted_event['end'] = end_time
      #no allDay in freebusy response, so time difference must be checked
      if event['start'].to_datetime + 1.day <= event['end'].to_datetime
        formatted_event['allDay'] = true
      else
        formatted_event['allDay'] = false
      end
      formatted_event_array << formatted_event 
    end

    return formatted_event_array
  end

  def get_own_events(social_object, start_time, end_time, timezone)#start_time and end_time must be string
    #own events get displayed when current user checks his/her own calendar aka events index page
    client = init_google_api_calendar_client(social_object)
    old_token = client.authorization.access_token
    service = client.discovered_api('calendar', 'v3')

    #API request/response
    result_raw = client.execute(
      :api_method => service.events.list,
      :parameters => { 'calendarId' => social_object.email,
                       'timeMin' => start_time,
                       'timeMax' => end_time,
                       'timeZone' => timezone },
      :headers => {'Content-Type' => 'application/json'})

    #token refresh if needed
    new_token = client.authorization.access_token
    if old_token != new_token
      social_object.update_attribute(:token, new_token)
      get_own_events(social_object, start_time, end_time, timezone)
    end

    #API response parsing
    result = JSON.parse(result_raw.body)['items']
    #result_timezone = JSON.parse(result_raw.body)['timeZone']

    #changing response to fullcalendar format
    formatted_event_array = []

    result.each do |event|
      if event['start']['dateTime'] && event['end']['dateTime']
        start_time = event['start']['dateTime'].to_datetime.rfc822
        end_time = event['end']['dateTime'].to_datetime.rfc822
        #timezone = result_timezone
        all_day = false
        title = event['summary']
        formatted_event = {}
        formatted_event['title'] = title
        formatted_event['start'] = start_time
        formatted_event['end'] = end_time
        formatted_event['allDay'] = all_day
        formatted_event_array << formatted_event
      elsif event['start']['date'] && event['end']['date']
        all_day = true
        start_time = event['start']['date'].to_datetime.rfc822
        end_time = event['end']['date'].to_datetime.rfc822
        title = event['summary']
        timezone = result_timezone
        formatted_event = {}
        formatted_event['title'] = title
        formatted_event['start'] = start_time
        formatted_event['end'] = end_time
        formatted_event['allDay'] = all_day
        formatted_event_array << formatted_event
      end
    end

    return formatted_event_array
  end
end










