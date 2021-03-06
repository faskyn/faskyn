class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_and_authorize_profile, only: [:show, :edit, :update, :add_socials]
  before_action :set_socials, only: [:add_socials, :show, :edit]

  def new
    @profile = Profile.new
    authorize @profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    authorize @profile
    if @profile.save
      redirect_to add_socials_user_profile_path(@profile.user), notice: "Profile successfully created!"
    else
      render action: :new, alert: "Profile couldn't be created!"
    end
  end

  def add_socials
  end

  def show
    @profile_products = @user.created_products.order(updated_at: :desc).includes(:industries)
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to user_profile_path(@profile.user), notice: "Profile updated!"
    else
      render :edit
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :company, :job_title, :location, :phone_number, :description)
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_and_authorize_profile
      @profile = @user.profile
      authorize @profile
    end

    def set_socials
      @twitter = @profile.socials.where(provider: "twitter").first
      @linkedin = @profile.socials.where(provider: "linkedin").first
    end
end

