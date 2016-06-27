require 'rails_helper'

feature "signing in" do
  let(:user) { create(:user) }

  scenario "successfully" do
    submit_paste(password: user.password)
    expect(page).to have_content("Signed in successfully.")
  end

  scenario "not successfull" do
    submit_paste(password: "haha")
    expect(page).to have_content("Invalid Email or Password.")
  end

  def submit_paste(password:)
    visit root_path
    within ".jumbotron" do
      click_on "LOG IN"
    end
    fill_in "user_email", with: user.email
    fill_in "user_password", with: password
    click_on "LOGIN"
  end
end