require 'rails_helper'

describe GroupInvitationsController do
  it { is_expected.to route(:patch, '/group_invitations/1/accept').to(action: :accept, id: 1) }
  it { is_expected.to route(:delete, '/group_invitations/1').to(action: :destroy, id: 1) }

  it { is_expected.to_not route(:post, '/group_invitations').to(action: :create) }
  it { is_expected.to_not route(:get, '/group_invitations/index').to(action: :index) }
  it { is_expected.to_not route(:get, '/group_invitations/new').to(action: :new) }
  it { is_expected.to_not route(:get, '/group_invitations/1').to(action: :show, id: 1) }
  it { is_expected.to_not route(:get, '/group_invitations/1/edit').to(action: :edit, id: 1) }
end

describe Products::GroupInvitationsController do
  it { is_expected.to route(:get, '/products/1/group_invitations/new').to(action: :new, product_id: 1) }
  it { is_expected.to route(:post, '/products/1/group_invitations').to(action: :create, product_id: 1) }
end

describe ProductCustomers::GroupInvitationsController do
  it { is_expected.to route(:post, 'product_customers/1/group_invitations').to(action: :create, product_customer_id: 1) }
end