require 'rails_helper'

describe NotificationsController do
  it { is_expected.to_not route(:get, 'users/1/notifications').to(action: :index, user_id: 1) }

  it { is_expected.to route(:get, 'users/1/chat_notifications').to(action: :chat_notifications, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/other_notifications').to(action: :other_notifications, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/chat_notifications_dropdown').to(action: :chat_notifications_dropdown, user_id: 1) }
  it { is_expected.to route(:get, 'users/1/other_notifications_dropdown').to(action: :other_notifications_dropdown, user_id: 1) }

  it { is_expected.to route(:get, 'users/1/checking_decreasing').to(action: :checking_decreasing, user_id: 1) }  
end