class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :delete, :destroy]
  before_action :only_current_user_product_change, only: [:edit, :update, :delete, :destroy]

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:products], per_page: 8)
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
        format.html { redirect_to user_tasks_path(current_user), notice: "Task got deleted!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task couldn't be deleted!"}
        format.js
      end
    end
  end

  private

    def product_params
      params.require(:product).permit(:name, :company, :website, :oneliner, :description, :usecase, :competition, industry_ids: [], industries_attributes: [:id, :name, :_destroy], product_features_attributes: [:id, :feature, :_destroy])
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def only_current_user_product_change
      redirect_to products_path, notice: "You can only change your own product." unless @product.user_id == current_user.id
    end
end
