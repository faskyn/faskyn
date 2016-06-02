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

describe Products::CommentsController do
  it { is_expected.to route(:post, '/products/1/comments').to(action: :create, product_id: 1) }
end

describe Posts::CommentsController do
  it { is_expected.to route(:post, 'posts/1/comments').to(action: :create, post_id: 1) }
end

describe ProductCustomers::CommentsController do
  it { is_expected.to route(:post, 'product_customers/1/comments').to(action: :create, product_customer_id: 1) }
end

describe ProductLeads::CommentsController do
  it { is_expected.to route(:post, 'product_leads/1/comments').to(action: :create, product_lead_id: 1) }
end

