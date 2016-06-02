class Products::GroupInvitationsController < GroupInvitationsController
  before_action :set_group_invitable
  
  def new
    authorize @product, :new_group_invitations?
    @product_users = @group_invitable.product_users.order(created_at: :desc)
    @product_group_invitations = @group_invitable.group_invitations.order(created_at: :desc)

    @product_customers = @product.product_customers
    @product_customer_users = @product.product_customer_users.order(created_at: :desc)
    @product_customer_group_invitations = @product_customers.map{ |pc| pc.group_invitations.order(created_at: :desc) }.flatten.uniq
  end

  private

    def set_group_invitable
      @group_invitable = Product.find(params[:product_id])
      @product = @group_invitable
    end
end