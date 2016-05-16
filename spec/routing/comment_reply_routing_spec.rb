require 'rails_helper'

describe Comments::CommentRepliesController do
  it { is_expected.to route(:post, '/comments/1/comment_replies').to(action: :create, comment_id: 1) }
  it { is_expected.to route(:patch, '/comments/1/comment_replies/1').to(action: :update, comment_id: 1, id: 1) }
  it { is_expected.to route(:delete, '/comments/1/comment_replies/1').to(action: :destroy, comment_id: 1, id: 1) }

  it { is_expected.to_not route(:get, '/comments/1/comment_replies/1').to(action: :show, comment_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/commentss/1/comment_replies').to(action: :index, comment_id: 1) }
  it { is_expected.to_not route(:get, '/commentss/1/posts_comment_replies/new').to(action: :new, comment_id: 1) } 
  it { is_expected.to_not route(:get, '/commentss/1/comment_replies/1').to(action: :edit, comment_id: 1) }
end