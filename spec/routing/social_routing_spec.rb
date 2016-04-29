require 'rails_helper'

describe SocialsController do
  it { is_expected.to_not route(:get, '/socials').to(action: :index) }
  it { is_expected.to_not route(:get, '/socials/new').to(action: :new) }
  it { is_expected.to route(:post, '/socials').to(action: :create) }
  it { is_expected.to_not route(:get, '/socials/1').to(action: :show, id: 1) }
  it { is_expected.to_not route(:get, '/socials/1/edit').to(action: :edit, id: 1) }
  it { is_expected.to route(:patch, '/socials/1').to(action: :update, id: 1) }
  it { is_expected.to route(:delete, '/socials/1').to(action: :destroy, id: 1) }
end