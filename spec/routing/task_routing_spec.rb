require 'rails_helper'

describe TasksController do
  it { is_expected.to route(:get, '/users/1/tasks').to(action: :index, user_id: 1) }

  it { is_expected.to route(:get, '/users/1/tasks/incoming_tasks').to(action: :incoming_tasks, user_id: 1) }
  it { is_expected.to route(:get, '/users/1/tasks/outgoing_tasks').to(action: :outgoing_tasks, user_id: 1) }
  it { is_expected.to route(:get, '/users/1/tasks/completed_tasks').to(action: :completed_tasks, user_id: 1) }

  it { is_expected.to_not route(:get, '/users/1/tasks/new').to(action: :new, user_id: 1) }
  it { is_expected.to route(:post, '/users/1/tasks').to(action: :create, user_id: 1) }
  it { is_expected.to_not route(:get, '/users/1/tasks/1').to(action: :show, user_id: 1, id: 1) }
  it { is_expected.to route(:get, '/users/1/tasks/1/edit').to(action: :edit, user_id: 1, id: 1) }
  it { is_expected.to route(:patch, '/users/1/tasks/1').to(action: :update, user_id: 1, id: 1) }

  it { is_expected.to route(:patch, '/users/1/tasks/1/complete').to(action: :complete, user_id: 1, id: 1) }
  it { is_expected.to route(:patch, '/users/1/tasks/1/uncomplete').to(action: :uncomplete, user_id: 1, id: 1) }

  it { is_expected.to route(:delete, '/users/1/tasks/1').to(action: :destroy, user_id: 1, id: 1) }
end