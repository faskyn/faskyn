require 'rails_helper'

feature "creating profile" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  scenario "successfully" do
    sign_in(user)
    visit user_profile_path(user)
    click_on "Edit Profile"
    fill_in "profile[first_name]", with: "Jack"
    fill_in "profile[last_name]", with: "Black"
    click_on "Save profile"
    expect(page).to have_content("Profile updated!")
    expect(page).to have_content("Jack Black")
  end
end