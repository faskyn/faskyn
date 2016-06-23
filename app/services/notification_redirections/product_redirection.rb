class NotificationRedirections::ProductRedirection
  include Rails.application.routes.url_helpers
  attr_reader :product_id

  def initialize(notification:)
    @product_id = notification.notifiable_id
  end

  def accepted
    product_product_owner_panels_path(product_id)
  end

  def commented
    product_path(product_id, anchor: "comment-panel")
  end

  def invited
    product_path(product_id, anchor: "product-invitation-well")
  end
end

