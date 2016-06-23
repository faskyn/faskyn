class NotificationRedirections::ProductLeadRedirection
  include Rails.application.routes.url_helpers
  attr_reader :product_lead_id

  def initialize(notification:)
    @product_lead_id = notification.notifiable_id
  end

  def commented
    product_product_lead_path(product_id, product_lead_id, anchor: "comment-panel")
  end

  private

    def product_id
      product_lead = ProductLead.find(product_lead_id)
      product_lead.product_id
    end
end