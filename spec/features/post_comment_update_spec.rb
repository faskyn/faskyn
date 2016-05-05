require 'rails_helper'

feature "updating post comment" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user ) }
  let(:post) { create(:post, user: user, body: "original post body") }
  let!(:post_comment) { create(:post_comment, user: user, post: post, body: "original post comment body") }
  let!(:other_post_comment ) { create(:post_comment, user: other_user, post: post, body: "original other post comment body") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#postcomment-#{post_comment.id}" do
      page.find(".post-comment-body").hover
      expect(page).to have_css("#activate-comment-edit-#{post_comment.id}")
      page.find("#activate-comment-edit-#{post_comment.id}").click
    end
    bip_text post_comment, :body, "new post comment body"
    expect(page).to have_content("new post comment body")
    expect(page).to_not have_content("original post comment body")
    page.find("#navbar-home").click
    expect(page).to have_content("new post comment body")
  end

  scenario "not allowed for others", js: true do
    sign_in(user)
    visit root_path
    within "#postcomment-#{other_post_comment.id}" do
      page.find(".post-comment-body").hover
      expect(page).to_not have_css("#activate-comment-edit-#{post_comment.id}")
    end
  end
end