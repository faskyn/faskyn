require 'rails_helper'

describe Products::ProductOwnerPanelsController do
  it { is_expected.to route(:get, '/products/1/product_owner_panels').to(action: :index, product_id: 1) }
end