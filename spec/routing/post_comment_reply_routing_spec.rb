require 'rails_helper'

describe Posts::PostCommentRepliesController do
  it { is_expected.to route(:post, '/post_comments/1/post_comment_replies').to(action: :create, post_comment_id: 1) }
  it { is_expected.to route(:patch, '/post_comments/1/post_comment_replies/1').to(action: :update, post_comment_id: 1, id: 1) }
  it { is_expected.to route(:delete, '/post_comments/1/post_comment_replies/1').to(action: :destroy, post_comment_id: 1, id: 1) }

  it { is_expected.to_not route(:get, '/post_comments/1/post_comment_replies/1').to(action: :show, post_comment_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/post_commentss/1/post_comment_replies').to(action: :index, post_comment_id: 1) }
  it { is_expected.to_not route(:get, '/post_commentss/1/posts_comment_replies/new').to(action: :new, post_comment_id: 1) } 
  it { is_expected.to_not route(:get, '/post_commentss/1/post_comment_replies/1').to(action: :edit, post_comment_id: 1) }
end