class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_and_authorize_company, only: [:show, :edit, :update]


  def show
  end

  def new
    authorize @product, :new_company?
    @company = Company.new
  end

  def create
    authorize @product, :create_company?
    @company = @product.build_company(company_params)
    if @company.save
      redirect_to product_company_path(@product), notice: "Company successfully created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update_attributes(company_params)
      redirect_to product_company_path(@product), notice: "Company successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    authorize @product, :destroy_company?
    if @product.company.destroy
      redirect_to product_path(@product), notice: "Company got deleted!"
    else
      redirect_to product_path(@product), notice: "Company couldn't be deleted!"
    end
  end

  private

    def company_params
      params.require(:company).permit(:name, :location, :website, :founded, :team_size, :revenue_type, :revenue, :engineer_number, :investment, :investor, :company_pitch_attachment, :company_pitch_attachment_id, :company_pitch_attachment_cache_id, :remove_company_pitch_attachment)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_and_authorize_company
      @company = @product.company
      authorize @company
    end
end