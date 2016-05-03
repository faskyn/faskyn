require 'rails_helper'

feature "creating profile" do
  let(:user) { create(:user, profile: nil) }
  scenario "successfully" do
    sign_in(user)
    visit root_path
    click_on "CREATE PROFILE"
    fill_in "profile[first_name]", with: "John"
    fill_in "profile[last_name]", with: "Doe"
    fill_in "profile[company]", with: "Performance Inc"
    fill_in "profile[job_title]", with: "General Partner"
    click_on "Save profile"
    expect(page).to have_content("Profile successfully created!")
    expect(page).to have_content("Skip")
  end

  scenario "adding twitter and linkedin"
end