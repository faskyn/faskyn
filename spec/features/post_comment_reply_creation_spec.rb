require 'rails_helper'

feature "creating post comment reply" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:post) { create(:post, user: user) }
  let!(:post_comment) { create(:post_comment, user: user, post: post) }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#postcomment-#{post_comment.id}" do
      find(".open-post-comment-reply").click
      fill_in "post_comment_reply[body]", with: "new post comment reply body"
    end
    find("#post-comment-reply-text-area-#{post_comment.id}").native.send_keys(:return)
    expect(page).to have_content("new post comment reply body")
    # page.find("#navbar-home").click
    # within "#postcomment-#{post_comment.id}" do
    #   find(".open-post-comment-reply").click
    # end
    # expect(page).to have_content("new post comment reply body")
  end
end