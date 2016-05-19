class Products::ProductCustomersController < ApplicationController
  before_action :authenticate_user!

  def show
    @product = Product.find(params[:product_id])
    @product_customer = ProductCustomer.find(params[:id])
    authorize @product_customer
    @comments = @product_customer.comments.ordered_with_profile
  end
end