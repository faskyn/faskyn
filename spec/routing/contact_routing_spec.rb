require 'rails_helper'

describe ContactsController do
  it { is_expected.to route(:post, '/contacts').to(action: :create) }
  it { is_expected.to route(:get, '/contacts/new').to(action: :new) }
end