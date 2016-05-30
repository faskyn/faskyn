class Products::ProductOwnerPanelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def index
    authorize @product, :index_product_owner_panels?
    @product_users = @product.product_users.order(created_at: :desc)
    @product_invitations = @product.product_invitations.order(created_at: :desc)
    @product_customer_users = @product.product_customer_users.order(created_at: :desc)
  end

  private

    def set_product
      @product = Product.find(params[:product_id])
    end
end