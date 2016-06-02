require 'rails_helper'

describe Products::ProductLeadsController do
  it { is_expected.to route(:get, '/products/1/product_leads/1').to(action: :show, product_id: 1, id: 1) }
end