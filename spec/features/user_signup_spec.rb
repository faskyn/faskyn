require 'rails_helper'

feature "signing up" do

  scenario "successfully" do
    visit root_path
    within ".jumbotron" do
      click_on "GET STARTED"
    end
    fill_in "user_email", with: "exampleemail@gmail.com"
    fill_in "user_password", with: "abc12345678"
    fill_in "user_password_confirmation", with: "abc12345678"
    click_on "CREATE YOUR ACCOUNT"
    expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
  end

  scenario "not successfull" do
    visit root_path
    within ".jumbotron" do
      click_on "GET STARTED"
    end
    fill_in "user_email", with: "exampleemail2@gmail.com"
    fill_in "user_password", with: "abc12345678"
    fill_in "user_password_confirmation", with: "abc1234567"
    click_on "CREATE YOUR ACCOUNT"
    expect(page).to have_content("Password confirmation doesn't match password")
  end 
end