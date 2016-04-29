require 'rails_helper'

describe ProfilesController do
  it { is_expected.to_not route(:get, 'users/1/profiles').to(action: :index, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/profile/new').to(action: :new, user_id: 1) }
  it { is_expected.to route(:post, 'users/1/profile').to(action: :create, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/profile').to(action: :show, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/profile/edit').to(action: :edit, user_id: 1) }
  it { is_expected.to route(:patch, 'users/1/profile').to(action: :update, user_id: 1) }
  it { is_expected.to_not route(:delete, 'users/1/profile').to(action: :destroy, user_id: 1) }
end