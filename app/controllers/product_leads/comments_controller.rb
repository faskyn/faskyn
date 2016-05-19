class ProductLeads::CommentsController < CommentsController
  before_action :set_commentable

  private

    def set_commentable
      @commentable = ProductLead.find(params[:product_lead_id])
    end
end