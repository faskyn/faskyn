require 'rails_helper'

feature "updating post comment reply" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user ) }
  let(:post) { create(:post, user: user, body: "post body") }
  let(:post_comment) { create(:post_comment, user: user, post: post, body: "post comment body") }
  let!(:post_comment_reply) { create(:post_comment_reply, user: user, post_comment: post_comment, body: "original post comment reply body") }
  let!(:other_post_comment_reply ) { create(:post_comment_reply, user: other_user, post_comment: post_comment, body: "original other post comment reply body") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#postcomment-#{post_comment.id}" do
      find('[data-behavior="open-post-comment-reply"]').click
      within "#postcommentreply-#{post_comment_reply.id}" do
        find('[data-behavior="post-comment-reply-body"]').hover
        expect(page).to have_css("#activate-comment-reply-edit-#{post_comment_reply.id}")
        page.find("#activate-comment-reply-edit-#{post_comment_reply.id}").click
      end
    end
    bip_text post_comment_reply, :body, "new post comment reply body"
    expect(page).to have_content("new post comment reply body")
    expect(page).to_not have_content("original post comment reply body")
  end

  scenario "not allowed for others", js: true do
    sign_in(user)
    visit root_path
    within "#postcomment-#{post_comment.id}" do
      find('[data-behavior="open-post-comment-reply"]').click
      within "#postcommentreply-#{other_post_comment_reply.id}" do
        page.find('[data-behavior="post-comment-reply-body"]').hover
        expect(page).to_not have_css("#activate-comment-reply-edit-#{other_post_comment_reply.id}")
      end
    end
  end
end