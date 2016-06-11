module ProductsHelper

  def twitter_product_share_text(product)
    TwitterProductShare.new(product).return_text
  end
end