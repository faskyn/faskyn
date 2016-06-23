class NotificationRedirections::PostRedirection
  include Rails.application.routes.url_helpers
  attr_reader :post_id

  def initialize(notification:)
    @post_id = notification.notifiable_id
  end

  def commented
    posts_path(anchor: "post_#{post_id}")
  end
end