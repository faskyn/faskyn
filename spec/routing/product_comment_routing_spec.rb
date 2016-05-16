require 'rails_helper'

describe Products::CommentsController do
  it { is_expected.to route(:post, '/products/1/comments').to(action: :create, product_id: 1) }
  
  it { is_expected.to_not route(:patch, '/products/1/comments/1').to(action: :update, product_id: 1, id: 1) }
  it { is_expected.to_not route(:delete, '/products/1/comments/1').to(action: :destroy, product_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/products/1/comments/1').to(action: :show, product_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/products/1/comments').to(action: :index, product_id: 1) }
  it { is_expected.to_not route(:get, '/products/1/comments/new').to(action: :new, product_id: 1) } 
  it { is_expected.to_not route(:get, '/products/1/comments/1').to(action: :edit, product_id: 1) }
end