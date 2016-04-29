require 'rails_helper'

describe ProductsController do
  it { is_expected.to route(:get, '/products').to(action: :index) }
  it { is_expected.to route(:get, '/products/new').to(action: :new) }
  it { is_expected.to route(:post, '/products').to(action: :create) }
  it { is_expected.to route(:get, '/products/1').to(action: :show, id: 1) }
  it { is_expected.to route(:get, '/products/1/edit').to(action: :edit, id: 1) }
  it { is_expected.to route(:patch, '/products/1').to(action: :update, id: 1) }
  it { is_expected.to route(:delete, '/products/1').to(action: :destroy, id: 1) }

  it { is_expected.to route(:get, 'users/1/products').to(action: :own_products, user_id: 1) }
end