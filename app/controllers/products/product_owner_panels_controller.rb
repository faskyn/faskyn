class Products::ProductOwnerPanelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def index
    authorize @product, :index_product_owner_panels?
    
    @product_users = @product.product_users.order(created_at: :desc).includes(:user)
    @product_group_invitations = @product.group_invitations.order(created_at: :desc).includes(:recipient)

    @product_customers = @product.product_customers
    @product_customer_users = @product.product_customer_users.order(created_at: :desc).includes(:user)
    @product_customer_group_invitations = @product_customers.map{ |pc| pc.group_invitations.order(created_at: :desc).includes(:recipient) }.flatten.uniq
    @group_invitation = GroupInvitation.new
  end

  private

    def set_product
      @product = Product.find(params[:product_id])
    end
end