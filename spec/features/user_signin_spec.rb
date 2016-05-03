require 'rails_helper'

feature "signing in" do
  let(:user) { create(:user) }

  scenario "successfully" do
    visit root_path
    within ".jumbotron" do
      click_on "LOG IN"
    end
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_on "LOGIN"
    expect(page).to have_content("Signed in successfully.")
  end

  scenario "not successfull" do
    visit root_path
    within ".jumbotron" do
      click_on "LOG IN"
    end
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "a"
    click_on "LOGIN"
    expect(page).to have_content("Invalid email or password.")
  end 
end