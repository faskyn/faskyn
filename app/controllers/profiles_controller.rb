class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :if_profile_exists, only: [:new, :create]
  before_action :find_user_for_profile, except: :profile_twitter
  before_action :set_profile, only: [:show, :edit, :update]

  def new
    @profile = Profile.new
  end

  def create
    @profile = @user.build_profile(profile_params)
    if @profile.save
      redirect_to user_path(@profile.user), notice: "Profile successfully created!"
    else
      render action: :new, alert: "Profile couldn't be created!"
    end
  end

  def show
    @twitter = @profile.socials.where(provider: "twitter").first
    @linkedin = @profile.socials.where(provider: "linkedin").first
    @angellist = @profile.socials.where(provider: "angellist").first
  end

  def edit
    #users can only have one account from each platform
    @twitter = @profile.socials.where(provider: "twitter").first
    @linkedin = @profile.socials.where(provider: "linkedin").first
    @angellist = @profile.socials.where(provider: "angellist").first
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

    def only_current_user_profile_check
      @user = User.find(params[:user_id])
      redirect_to user_path(current_user), notice: "You can only check your own profile." unless @user == current_user
    end
end

