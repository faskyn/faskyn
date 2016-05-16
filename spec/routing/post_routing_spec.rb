require 'rails_helper'

describe PostsController do
  it { is_expected.to route(:get, '/posts/new').to(action: :new) }
  it { is_expected.to route(:post, '/posts').to(action: :create) }
  it { is_expected.to route(:get, '/posts/1').to(action: :show, id: 1) }
  it { is_expected.to route(:get, '/posts/1/edit').to(action: :edit, id: 1) }
  it { is_expected.to route(:patch, '/posts/1').to(action: :update, id: 1) }
  it { is_expected.to route(:delete, '/posts/1').to(action: :destroy, id: 1) }
end