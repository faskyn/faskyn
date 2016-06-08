class ProductCustomers::ProductCustomerUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_and_product_customer
  before_action :set_product_customer_user

  def destroy
    authorize @product, :destroy_product_customer_users?
    if @product_customer_user.destroy
      @user = @product_customer_user.user
      @product_customer.group_invitations.belonging_to_product_customer_user(@user).destroy_all
      redirect_to :back, notice: "User removed from product referencers!"
    end
  end

  private

    def set_product_and_product_customer
      @product_customer = ProductCustomer.find(params[:product_customer_id])
      @product = @product_customer.product
    end

    def set_product_customer_user
      @product_customer_user = ProductCustomerUser.find(params[:id])
    end
end
