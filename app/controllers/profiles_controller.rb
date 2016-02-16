class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_for_profile
  before_action :if_profile_exists, only: [:new, :create]
  before_action :if_no_profile_exists, only: :show
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :only_current_user_profile_change, only: [:edit, :update, :delete, :destroy]

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to user_path(@profile.user), notice: "Profile successfully created!"
    else
      render action: :new, alert: "Profile couldn't be created!"
    end
  end

  def show
    @twitter = @profile.socials.where(provider: "twitter").first
    @linkedin = @profile.socials.where(provider: "linkedin").first
  end

  def edit
    #users can only have one account from each platform
    @twitter = @profile.socials.where(provider: "twitter").first
    @linkedin = @profile.socials.where(provider: "linkedin").first
    @google = @profile.socials.where(provider: "google_oauth2").first
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to user_path(@profile.user), notice: "Profle updated!"
    else
      render action: :edit, alert: "Profile couldn't be updated!"
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :company, :job_title, :phone_number, :description)
    end

    def find_user_for_profile
      @user = User.find(params[:user_id])
    end

    def set_profile
      @profile = @user.profile
    end

    def only_current_user_profile_change
      redirect_to user_path(current_user), notice: "You can only change your own profile." unless @profile.user_id == current_user.id
    end
end

