require 'rails_helper'

feature "creating post comment" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:commentable) { create(:post, user: user) }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#post_#{commentable.id}" do
      fill_in "comment[body]", with: "new comment body"
    end
    find("#comment-text-area-#{commentable.id}").native.send_keys(:return)
    expect(page).to have_content("new comment body")
    page.find("#navbar-home").click
    expect(page).to have_content("new comment body")
  end
end