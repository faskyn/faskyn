class TwitterReviewShare
  URL_LENGTH = 23 #defined by twitter API
  SPACE_LENGTH = 1
  TWITTER_MAX = 140
  attr_reader :body, :product_name

  def initialize(review, product_customer)
    @body = review.body
    @product_name = product_customer.product.name
  end

  def return_text
    if full_length <= TWITTER_MAX
      return basic_body_text + basic_product_text
    else
      return basic_body_text[0...-(difference + text_end.length)] + text_end + basic_product_text
    end
  end

  private

    def basic_body_text
      %Q("#{body}") 
    end

    def basic_product_text
      " on #{product_name}"
    end

    def difference
      full_length - TWITTER_MAX
    end

    def full_length
      basic_body_text.length + basic_product_text.length + SPACE_LENGTH + URL_LENGTH
    end

    def text_end
      '..."'
    end
end