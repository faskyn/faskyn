class SocialsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      @profile = current_user.profile
      @social = @profile.socials.find_or_create_from_auth_hash(auth_hash)
      flash[:success] = "#{@social.provider.camelize} account was successfully updated!"
    rescue
      flash[:alert] = "There was an error while trying to authenticate you!"
    end
    redirect_to request.env['omniauth.origin'] || edit_user_profile_path(current_user)
  end

  def update
  end

  def destroy
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end
end
