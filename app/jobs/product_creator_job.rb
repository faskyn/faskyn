class ProductCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)
    ProductMailer.product_created(product).deliver if product.company.blank?
  end
end