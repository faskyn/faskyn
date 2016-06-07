class ReviewWriterJob < ActiveJob::Base
  queue_as :default

  def perform(review, product_customer)
    ReviewWriterMailer.review_writer_email(review, product_customer).deliver
  end
end