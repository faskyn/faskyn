class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_product_customer, only: :create
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_review, only: [:edit, :update]

  def create
    @review = @product_customer.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      #@review.send_review_creation_notification(@product_customer)
      respond_to :js
    else
      respond_to :js
    end
  end

  def edit
    respond_to :js
  end

  def update
    if @review.update_attributes(review_params)
      respond_to :js
    else
      respond_to :js
    end
  end

  def destroy
    authorize @review.product_customer, :destroy_review?
    if @review.destroy
      respond_to :js
    else
      respond_to :js
    end
  end

  private

    def review_params
      params.require(:review).permit(:body)
    end

    def set_and_authorize_product_customer
      @product_customer = ProductCustomer.find(params[:product_customer_id])
      authorize @product_customer, :create_reviews?
    end

    def set_review
      @review = Review.find(params[:id])
    end

    def authorize_review
      authorize @review
    end
end