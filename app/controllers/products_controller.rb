class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_product, only: [:show, :edit, :update, :destroy]

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
    @products = current_user.own_products.order(updated_at: :desc).paginate(page: params[:page], per_page: Product.pagination_per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
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
    @product.product_users.build(user_id: current_user.id, role: "owner")
    authorize @product
    if @product.save
      respond_to do |format|
        format.html { redirect_to @product, notice: "Product got created!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: :new, alert: "Product couldn't be created!" }
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
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Product got deleted!"}
      end
    else
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Product couldn't be deleted!"}
      end
    end
  end

  private

    def product_params
      params.require(:product).permit(:product_image, :remove_product_image, :product_image_cache,
        :name, :website, :oneliner, :description, industry_ids: [], user_ids: [],
        product_customers_attributes: [:id, :customer, :usage, :_destroy],
        product_leads_attributes: [:id, :lead, :pitch, :_destroy])
    end

    def product_users_params
      params.require(:product_user).permit(:user_id, :product_is, :role)
    end
    
    def set_and_authorize_product
      @product = Product.find(params[:id])
      authorize @product
    end
end
