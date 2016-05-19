class Products::ProductLeadsController < ApplicationController
  before_action :authenticate_user!

  def show
    @product = Product.find(params[:product_id])
    @product_lead = ProductLead.find(params[:id])
    authorize @product_lead
    @comments = @product_lead.comments.ordered_with_profile
  end
end