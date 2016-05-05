require 'rails_helper'

feature "creating post comment" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:post) { create(:post, user: user) }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#post_#{post.id}" do
      fill_in "post_comment[body]", with: "new post comment body"
    end
    find("#post-comment-text-area-#{post.id}").native.send_keys(:return)
    expect(page).to have_content("new post comment body")
    page.find("#navbar-home").click
    expect(page).to have_content("new post comment body")
  end
end