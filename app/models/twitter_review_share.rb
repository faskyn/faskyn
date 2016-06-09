class TwitterReviewShare
  URL_LENGTH = 23 #defined by twitter API
  TWITTER_MAX = 140
  attr_reader :body, :product_name

  def initialize(review, product_customer)
    @body = review.body
    @product_name = product_customer.product.name
  end

  def return_text
    if full_length <= TWITTER_MAX
      return basic_text
    else
      difference = URL_LENGTH - TWITTER_MAX
      return basic_text[0...-(difference + text_end.length)] + text_end
    end
  end

  def basic_text
    %Q("#{body}") + " on #{product_name}"
  end

  def full_length
    basic_text.length + URL_LENGTH
  end

  def text_end
    "..."
  end
end