module ApplicationHelper
  require 'rinku'

  def has_profile?
    current_user.profile
  end

  def find_links(message_body)
     found_link = Rinku.auto_link(message_body, mode=:all, 'target="_blank"', skip_tags=nil).html_safe
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def date_to_string(date)
    if date.nil?
      ""
    end
  end
end
