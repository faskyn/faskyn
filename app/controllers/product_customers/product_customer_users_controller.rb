class ProductCustomers::ProductCustomerUsersController < CommentsController
  before_action :authenticate_user!
  before_action :set_product_customer
  before_action :set_product_customer_user

  def destroy
    #authorize @product, :destroy_product_users?
    if @product_customer_user.destroy
      redirect_to :back, notice: "User removed from product referencers!"
    end
  end

  private

    def set_product_customer
      @product_customer = ProductCustomer.find(params[:product_customer_id])
    end

    def set_product_customer_user
      @product_customer_user = ProductCustomerUser.find(params[:id])
    end
end
