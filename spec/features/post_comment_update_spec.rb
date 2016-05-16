require 'rails_helper'

feature "updating post comment" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user ) }
  let(:commentable) { create(:post, user: user, body: "original body") }
  let!(:comment) { create(:comment, commentable: commentable, user: user, body: "original comment body") }
  let!(:other_comment ) { create(:comment, commentable: commentable, user: other_user, body: "original other comment body") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#comment-#{comment.id}" do
      page.find('[data-behavior="comment-body"]').hover
      expect(page).to have_css("#activate-comment-edit-#{comment.id}")
      page.find("#activate-comment-edit-#{comment.id}").click
    end
    bip_text comment, :body, "new comment body"
    expect(page).to have_content("new comment body")
    expect(page).to_not have_content("original comment body")
    page.find("#navbar-home").click
    expect(page).to have_content("new comment body")
  end
end