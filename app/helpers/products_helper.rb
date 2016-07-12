module ProductsHelper

  def twitter_product_share_text(product)
    TwitterProductShare.new(product).return_text
  end

  def back_from_form(action, product)
    if action == "edit"
      link_to "Back to Product", product_path(product), class: "btn btn-default back-button"
    elsif action == "new"
      link_to "Back to Products", products_path, class: "btn btn-default back-button"
    end
  end
end