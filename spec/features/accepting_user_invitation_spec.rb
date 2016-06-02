# require 'rails_helper'

# feature "accepting user invitation" do
#   background do
#     User.invite!({ email: "deviseinvited111@gmail.com" })
#   end

#   let!(:user) { User.find_by(email: "deviseinvited111@gmail.com") }
#   scenario "successfully" do
#     #visit accept_user_invitation_url(user, invitation_token: user.invitation_token)
#     visit "/users/invitation/accept.#{user.id}?invitation_token=#{user.invitation_token}" 
#     save_and_open_page
#     fill_in "user[password]", with: "devise0000"
#     fill_in "user[password_confirmation]", with: "devise0000"
#     click_on "CREATE YOUR ACCOUNT"
#     expect(page).to have_content("Your password was set successfully. You are now signed in.")
#   end
# end
