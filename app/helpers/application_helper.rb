module ApplicationHelper
  require 'rinku'

  def has_profile?
    current_user.profile if current_user.present?
  end

  def find_links(text)
    found_link = Rinku.auto_link(text, mode=:all, 'target="_blank"', skip_tags=nil).html_safe
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def bootstrap_alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      danger: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-success'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def human_model_name(notifiable_type)
    notifiable_type.tableize.singularize.humanize.downcase
  end
end
