class SocialsController < ApplicationController
  before_action :authenticate_user!

  def create
    #when user clicks on button to authorize the given social site
    #google calendar needs refresh token (new query on every calendar click) unlike the linkedin and twitter
    begin
      @profile = current_user.profile
      @social = @profile.socials.find_or_create_from_auth_hash(auth_hash)
      if auth_hash.provider == "google_oauth2"
        flash[:success] = "Your faskyn calendar is now connected to your google calendar!"
      else  
        flash[:success] = "#{@social.provider.camelize} account was successfully updated!"
      end
    rescue
      flash[:warning] = "There was an error while trying to authenticate you!"
    end
    redirect_to edit_user_profile_path(current_user)
  end

  def update
  end

  def destroy
  end

  private

    def social_params
      params.require(:social).permit(:provider, :uid, :token, :secret, :first_name, :last_name, :page_url, :picture_url, :location, :description, :phone, :email, :refresh_token, :expires_at)
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
