class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user, except: [:show]
  before_action :if_profile_exists, only: [:new, :create]
  before_action :find_user_for_profile
  before_action :set_profile, only: [:show, :edit, :update]

  def new
    @profile = Profile.new
  end

  def create
    @profile = @user.build_profile(profile_params)
    if @profile.save
      flash[:success] = "Profile Updated!"
      redirect_to user_path(params[:user_id])
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile Updated!"
      redirect_to user_path(params[:user_id])
    else
      render action: :edit
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
end

