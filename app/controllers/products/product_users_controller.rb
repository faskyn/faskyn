class Products::ProductUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_product_user, only: :destroy

  def index
    authorize @product, :index_product_users?
    @product_users = @product.product_users.order(created_at: :desc)
    @product_invitations = @product.product_invitations.order(created_at: :desc)
  end

  def destroy
    authorize @product, :destroy_product_users?
    if @product_user.destroy
      @product.product_invitations.where('recipient_id = ?', @product_user.user_id).destroy_all
      redirect_to :back, notice: "User removed from product members!"
    end
  end

  private

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_product_user
      @product_user = ProductUser.find(params[:id])
    end
end