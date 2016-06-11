module ReviewsHelper

  def twitter_review_share_text(review, product_customer)
    TwitterReviewShare.new(review, product_customer).return_text
  end
end