require 'rails_helper'

describe Posts::CommentsController do
  it { is_expected.to route(:post, '/posts/1/comments').to(action: :create, post_id: 1) }
  
  it { is_expected.to_not route(:patch, '/posts/1/comments/1').to(action: :update, post_id: 1, id: 1) }
  it { is_expected.to_not route(:delete, '/posts/1/comments/1').to(action: :destroy, post_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/posts/1/comments/1').to(action: :show, post_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/posts/1/comments').to(action: :index, post_id: 1) }
  it { is_expected.to_not route(:get, '/posts/1/comments/new').to(action: :new, post_id: 1) } 
  it { is_expected.to_not route(:get, '/posts/1/comments/1').to(action: :edit, post_id: 1) }
end