class ProductMailer < ActionMailer::Base
  default from: 'faskyn@gmail.com'

  def product_created(product)
    @product = product

    mail(
        to: "#{@product.owner.email}",
        subject: "[Faskyn] Add company info to #{ @product.name }"
        )
  end
end