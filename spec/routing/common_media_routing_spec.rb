require 'rails_helper'

describe CommonMediasController do
  it { is_expected.to route(:get, 'users/1/common_medias').to(action: :common_medias, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/common_medias/get_links').to(action: :get_links, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/common_medias/get_files').to(action: :get_files, user_id: 1) }
end