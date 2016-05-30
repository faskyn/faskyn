class Products::ProductUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_product_user

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