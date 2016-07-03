require 'rails_helper'

describe CompaniesController do
  it { is_expected.to_not route(:get, 'products/1/companies').to(action: :index, product_id: 1) }
  it { is_expected.to route(:get, 'products/1/company/new').to(action: :new, product_id: 1) }
  it { is_expected.to route(:post, 'products/1/company').to(action: :create, product_id: 1) }
  it { is_expected.to route(:get, 'products/1/company').to(action: :show, product_id: 1) }
  it { is_expected.to route(:get, 'products/1/company/edit').to(action: :edit, product_id: 1) }
  it { is_expected.to route(:patch, 'products/1/company').to(action: :update, product_id: 1) }
  it { is_expected.to route(:delete, 'products/1/company').to(action: :destroy, product_id: 1) }
end