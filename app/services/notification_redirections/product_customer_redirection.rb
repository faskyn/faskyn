class NotificationRedirections::ProductCustomerRedirection
  include Rails.application.routes.url_helpers
  attr_reader :product_customer_id

  def initialize(notification:)
    @product_customer_id = notification.notifiable_id
  end

  def accepted
    product_product_owner_panels_path(product_id)
  end

  def commented
    product_product_customer_path(product_id, product_customer_id, anchor: "comment-panel")
  end

  def invited
    product_product_customer_path(product_id, product_customer_id)
  end

  def wrote
    product_product_customer_path(product_id, product_customer_id)
  end

  private

    def product_id
      product_customer = ProductCustomer.find(product_customer_id)
      product_customer.product_id
    end
end
