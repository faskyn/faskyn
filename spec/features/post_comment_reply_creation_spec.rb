require 'rails_helper'

feature "creating post comment reply" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:commentable) { create(:post, user: user) }
  let!(:comment) { create(:comment, commentable: commentable, user: user) }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#comment-#{comment.id}" do
      find('[data-behavior="open-comment-reply"]').click
      fill_in "comment_reply[body]", with: "new comment reply body"
    end
    find("#comment-reply-text-area-#{comment.id}").native.send_keys(:return)
    expect(page).to have_content("new comment reply body")
  end
end