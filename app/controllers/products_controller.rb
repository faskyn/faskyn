class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :delete, :destroy]
  before_action :only_current_user_product_change, only: [:edit, :update, :delete, :destroy]

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:products], per_page: Product.pagination_per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def own_products
    @products = current_user.products.order(created_at: :desc).paginate(page: params[:products], per_page: 8)
  end

  def show
  end

  def new
    @product = Product.new
    @product.industry_products.build
    @product.product_features.build
    @product.product_usecases.build
    @product.product_competitions.build
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      respond_to do |format|
        format.html { redirect_to @product, notice: "Product saved!" }
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

  def delete
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
      params.require(:product).permit(:product_image, :product_image_url, :product_image_id, :product_image_cache_id, :remove_product_image, :product_image_size, :product_image_name,
        :name, :company, :website, :oneliner, :description,
        industry_ids: [], industries_attributes: [:id, :name, :_destroy],
        product_features_attributes: [:id, :feature, :_destroy],
        product_usecases_attributes: [:id, :example, :detail, :_destroy],
        product_competitions_attributes: [:id, :competitor, :differentiator, :_destroy])
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def only_current_user_product_change
      redirect_to products_path, notice: "You can only change your own product." unless @product.user_id == current_user.id
    end
end
