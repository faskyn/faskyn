require 'rails_helper'

describe MessagesController do
  it { is_expected.to_not route(:get, '/conversations/1/messages').to(action: :index, conversation_id: 1) }
  it { is_expected.to_not route(:get, '/conversations/1/messages/new').to(action: :new, conversation_id: 1) }
  it { is_expected.to route(:post, '/conversations/1/messages').to(action: :create, conversation_id: 1) }
  it { is_expected.to_not route(:get, '/conversations/1/messages/1').to(action: :show, conversation_id: 1, id: 1) }
  it { is_expected.to_not route(:get, '/conversations/1/messages/1/edit').to(action: :edit, conversation_id: 1, id: 1) }
  it { is_expected.to_not route(:patch, '/conversations/1/messages/1').to(action: :update, conversation_id: 1, id: 1) }
  it { is_expected.to_not route(:delete, '/conversations/1/messages/1').to(action: :destroy, conversation_id: 1, id: 1) }
end