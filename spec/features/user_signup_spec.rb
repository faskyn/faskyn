require 'rails_helper'

feature "signing up" do

  scenario "successfully" do
    submit_paste(email: "exampleemail@gmail.com", password: "abc12345678", password_confirmation: "abc12345678")
    expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
  end

  scenario "not successfull" do
    submit_paste(email: "exampleemail2@gmail.com", password: "abc12345678", password_confirmation: "haha")
    expect(page).to have_content("Password confirmation doesn't match password")
  end

  def submit_paste(email:, password:, password_confirmation:)
    visit root_path
    within ".jumbotron" do
      click_on "GET STARTED"
    end
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password_confirmation
    click_on "CREATE YOUR ACCOUNT"
  end
end