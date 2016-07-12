class ReviewWriterJob < ActiveJob::Base
  queue_as :default

  def perform(review_id, product_customer_id)
    review = Review.find(review_id)
    product_customer = ProductCustomer.find(product_customer_id)
    ReviewWriterMailer.review_writer_email(review, product_customer).deliver
  end
end