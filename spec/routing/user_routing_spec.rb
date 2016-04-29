require 'rails_helper'

describe UsersController do
  it { is_expected.to route(:get, '/users').to(action: :index) }
  it { is_expected.to route(:get, '/users/1').to(action: :show, id: 1) }

  it "checks devise routes"
end