module ControllerMacros
  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create(:user)
    #@user.confirm!
    sign_in @user
  end
end