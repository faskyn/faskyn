module ApplicationHelper
  require 'rinku'

  def has_profile?
    current_user.profile
  end

  def find_links(message_body)
     Rinku.auto_link(message_body, mode=:all, 'target="_blank"', skip_tags=nil).html_safe 
  end

  def date_to_string(date)
    if date.nil?
      ""
    end
  end
end
