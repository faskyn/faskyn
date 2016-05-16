require 'rails_helper'

feature "updating post comment reply" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user ) }
  let(:commentable) { create(:post, user: user, body: "post body") }
  let(:comment) { create(:comment, commentable: commentable, user: user, body: "comment body") }
  let!(:comment_reply) { create(:comment_reply, comment: comment, user: user, body: "original comment reply body") }
  let!(:other_comment_reply ) { create(:comment_reply, comment: comment, user: other_user, body: "original other comment reply body") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#comment-#{comment.id}" do
      find('[data-behavior="open-comment-reply"]').click
      within "#commentreply-#{comment_reply.id}" do
        find('[data-behavior="comment-reply-body"]').hover
        expect(page).to have_css("#activate-comment-reply-edit-#{comment_reply.id}")
        page.find("#activate-comment-reply-edit-#{comment_reply.id}").click
      end
    end
    bip_text comment_reply, :body, "new comment reply body"
    expect(page).to have_content("new comment reply body")
    expect(page).to_not have_content("original comment reply body")
  end

  scenario "not allowed for others", js: true do
    sign_in(user)
    visit root_path
    within "#comment-#{comment.id}" do
      find('[data-behavior="open-comment-reply"]').click
      within "#commentreply-#{other_comment_reply.id}" do
        page.find('[data-behavior="comment-reply-body"]').hover
        expect(page).to_not have_css("#activate-comment-reply-edit-#{other_comment_reply.id}")
      end
    end
  end
end