require 'rails_helper'

describe CommentsController do
  it { is_expected.to route(:patch, '/comments/1').to(action: :update, id: 1) }
  it { is_expected.to route(:delete, '/comments/1').to(action: :destroy, id: 1) }

  it { is_expected.to_not route(:post, '/comments').to(action: :create) }
  it { is_expected.to_not route(:get, '/comments/index').to(action: :index) }
  it { is_expected.to_not route(:get, '/comments/new').to(action: :new) }
  it { is_expected.to_not route(:get, '/comments/1').to(action: :show, id: 1) }
  it { is_expected.to_not route(:get, '/comments/1/edit').to(action: :edit, id: 1) }
end