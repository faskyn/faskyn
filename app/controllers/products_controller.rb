class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_product, only: [:show, :edit, :update, :delete, :destroy]

  def index
    @q_products = Product.ransack(params[:q])
    @products = @q_products.result(distinct: true).order(created_at: :desc).paginate(page: params[:products], per_page: Product.pagination_per_page)
    authorize @products
    respond_to do |format|
      format.html
      format.js
    end
  end

  def own_products
    @user = User.find(params[:user_id])
    authorize @user, :show_own_products?
    @q_products = current_user.products.ransack(params[:q])
    @products = @q_products.result(distinct: true).order(updated_at: :desc).paginate(page: params[:products], per_page: Product.pagination_per_page)
    authorize @products
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @product = Product.new
    authorize @product
    @product.industry_products.build
    @product.product_features.build
    @product.product_usecases.build
    @product.product_competitions.build
  end

  def create
    @product = current_user.products.new(product_params)
    authorize @product
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
      params.require(:product).permit(:product_image, :remove_product_image,
        :name, :company, :website, :oneliner, :description, industry_ids: [],
        product_features_attributes: [:id, :feature, :_destroy],
        product_usecases_attributes: [:id, :example, :detail, :_destroy],
        product_competitions_attributes: [:id, :competitor, :differentiator, :_destroy])
    end

    def set_and_authorize_product
      @product = Product.find(params[:id])
      authorize @product
    end
end
