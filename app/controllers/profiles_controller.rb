class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user, except: [:show, :profile_twitter]
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
  end

  def profile_twitter
    #callback from twitter is redirected to here
    # current_user.profile.update_attributes(
    #   twitter_url: ,
    #   twitter_pic: )
    redirect_to edit_user_profile_path(current_user, auth_hash.uid), notice: "Twitter connected!"
  end

  def edit
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

    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to user_path(current_user) unless @user == current_user
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end

