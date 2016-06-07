require 'rails_helper'

describe ReviewsController do
  it { is_expected.to route(:post, '/product_customers/1/reviews').to(action: :create, product_customer_id: 1) }
  it { is_expected.to route(:get, '/reviews/1/edit').to(action: :edit, id: 1) }
  it { is_expected.to route(:patch, '/reviews/1').to(action: :update, id: 1) }
  it { is_expected.to route(:delete, '/reviews/1').to(action: :destroy, id: 1) }

  it { is_expected.to_not route(:get, '/reviews/index').to(action: :index) }
  it { is_expected.to_not route(:get, '/reviews/new').to(action: :new) }
  it { is_expected.to_not route(:get, '/reviews/1').to(action: :show, id: 1) }
end