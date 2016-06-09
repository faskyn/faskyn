class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_product, only: [:show, :edit, :update, :destroy, :product_members]

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: Product.pagination_per_page)
    authorize @products
    respond_to do |format|
      format.html
      format.js
    end
  end

  def own_products
    @user = User.find(params[:user_id])
    authorize @user, :index_own_products?
    @products = current_user.created_products.order(updated_at: :desc).paginate(page: params[:page], per_page: Product.pagination_per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @users = @product.users.includes(:profile)
    @comments = @product.comments.ordered_with_profile
  end

  def new
    @product = Product.new
    authorize @product
    @product.industry_products.build
    @product.product_customers.build
    @product.product_leads.build
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    @product.product_users.build(user_id: current_user.id, role: "owner")
    authorize @product
    if @product.save
      respond_to do |format|
        format.html { redirect_to new_product_group_invitation_path(@product), notice: "Product got created!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      respond_to do |format|
        format.html { redirect_to @product, notice: "Product was successfully updated!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: :edit, alert: "Product couldn't be updated!"}
        format.js
      end
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: "Product got deleted!"
    else
      redirect_to products_path, notice: "Product couldn't be deleted!"
    end
  end

  private

    def product_params
      params.require(:product).permit(:product_image, :remove_product_image, :product_image_cache,
        :name, :website, :oneliner, :description, industry_ids: [], user_ids: [],
        product_customers_attributes: [:id, :customer, :usage, :website, :_destroy],
        product_leads_attributes: [:id, :lead, :pitch, :website, :_destroy])
    end

    def product_users_params
      params.require(:product_user).permit(:user_id, :product_is, :role)
    end
    
    def set_and_authorize_product
      @product = Product.find(params[:id])
      authorize @product
    end
end
