module Features
  def sign_in(user=nil)
    current_user = user || FactoryGirl.create(:user)
    login_as(current_user, scope: :user)
  end
end