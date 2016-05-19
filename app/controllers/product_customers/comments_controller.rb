class ProductCustomers::CommentsController < CommentsController
  before_action :set_commentable

  private

    def set_commentable
      @commentable = ProductCustomer.find(params[:product_customer_id])
    end
end