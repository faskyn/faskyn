class ProductCustomers::GroupInvitationsController < GroupInvitationsController
  before_action :set_group_invitable

  private

    def set_group_invitable
      @group_invitable = ProductCustomer.find(params[:product_customer_id])
      @product = @group_invitable.product
    end
end