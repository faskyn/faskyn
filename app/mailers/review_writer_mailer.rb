class ReviewWriterMailer < ActionMailer::Base
  default from: 'faskyn@gmail.com'

  def review_writer_email(review, product_customer)
    @review = review
    @product_customer = product_customer

    mail(
        to: "#{@product_customer.owner.email}",
        subject: "[Faskyn] #{ @review.user.full_name } wrote a review"
        )
  end
end