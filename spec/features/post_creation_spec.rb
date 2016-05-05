require 'rails_helper'

feature "creating post" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    fill_in "post[body]", with: "new post body"
    click_on "SHARE"
    #find('#q_name').native.send_keys(:return)
    expect(page).to have_content("new post body")
    page.find("#navbar-home").click
    expect(page).to have_content("new post body")
  end
end