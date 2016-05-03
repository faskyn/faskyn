require "rails_helper"
# require "pry"

describe TasksController do

  describe "when user is not logged in" do
    let(:user) { create(:user) }

    it "GET index redirects to login" do
      get :index, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET incoming_tasks redirects to login" do
      get :incoming_tasks, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET outgoing_tasks redirects to login" do
      get :outgoing_tasks, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET completed_tasks redirects to login" do
      get :completed_tasks, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end
  
    describe "collections" do
      let!(:user) { create(:user) }
      let!(:assigned_task) { create(:task, assigner: @user, executor: user, deadline: DateTime.now + 2) }
      let!(:executed_task) { create(:task, executor: @user, assigner: user, deadline: DateTime.now + 3) }
      let!(:completed_task) { create(:task, executor: @user, assigner: user, completed_at: DateTime.now - 2) } 
      let!(:profile) { create(:profile, user: @user) }
      let!(:profile_2) { create(:profile, user: user) }
      let!(:other_task) { create(:task) }

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end

      context "GET index" do
        before(:each) do
          get :index, user_id: @user.id
        end
        
        it "assigns user's tasks" do
          expect(assigns(:tasks)).to eq([executed_task, assigned_task])
        end

        it "assigns new task" do
          expect(assigns(:task)).to be_a_new(Task)
        end

        it "doesn't assign other user's tasks" do
          expect(assigns(:tasks)).to_not include(other_task)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :index }
      end

      context "GET incoming_tasks" do
        before(:each) do
          get :incoming_tasks, user_id: @user.id
        end

        it "assigns user's incoming tasks" do
          expect(assigns(:tasks)).to eq([executed_task])
        end

        it "doesn't assign user's incoming tasks" do
          expect(assigns(:tasks)).to_not include([assigned_task])
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :incoming_tasks }
      end

      context "GET outgoing_tasks" do
        before(:each) do
          get :outgoing_tasks, user_id: @user.id
        end

        it "assigns user's outgoing tasks" do
          expect(assigns(:tasks)).to eq([assigned_task])
        end

        it "assigns new task" do
          expect(assigns(:task)).to be_a_new(Task)
        end

        it "doesn't assign user's incoming tasks" do
          expect(assigns(:tasks)).to_not include([executed_task])
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :outgoing_tasks }
      end

      context "GET completed_tasks" do
        before(:each) do
          get :completed_tasks, user_id: @user.id
        end

        it "assigns user's completed tasks" do
          expect(assigns(:tasks)).to eq([completed_task])
        end

        it "doesn't assign uncompleted tasks" do
          expect(assigns(:tasks)).to_not include(assigned_task)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :completed_tasks }
      end

      context "GET edit" do
        before(:each) do
          xhr :get, :edit, user_id: @user.id, id: assigned_task.id
        end

        it "assigns user's task" do
          expect(assigns(:task)).to eq(assigned_task)
        end

        it { is_expected.to respond_with 200 }
      end
    end

    describe "POST create" do
      let!(:user) { create(:user) }
      
      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, user_id: @user.id, task: attributes_for(:task, assigner_id: @user.id, executor_id: user.id) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ Task.count }.by(1)
        end

        it "sends notification" do
          expect{ create_action }.to change{ Notification.count }.by(1)
        end

        it 'triggers task email active job' do
          expect{ create_action }.to change{ ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
          #expect(TaskCreatorJob).to receive(:perform_later).once
          #create_action
        end

        it "responds with success" do
          create_action
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, user_id: @user.id, task: attributes_for(:task, assigner_id: @user.id, executor_id: user.id, content: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ Task.count }
        end

        it "doesn't send notification" do
          expect{ create_action }.to_not change{ Notification.count }
        end
      end
    end

    describe "PUT update" do
      let!(:task) { create(:task, assigner: @user, deadline: DateTime.now + 2, content: "original content") }
      
      context "with valid attributes" do

        it "assigns the task" do
          xhr :patch, :update, user_id: @user.id, id: task.id, task: attributes_for(:task)
          expect(assigns(:task)).to eq(task)
        end

        it "changes the attributes" do
          xhr :patch, :update, user_id: @user.id, id: task.id, task: attributes_for(:task, deadline: DateTime.now + 2 , content: "new content")
          task.reload
          expect(task.deadline).to be_within(1.day).of(DateTime.now + 2)
          expect(task.content).to eq("new content")
        end

        it "responds with success" do
          xhr :patch, :update, user_id: @user.id, id: task.id, task: attributes_for(:task)
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          xhr :patch, :update, user_id: @user.id, id: task.id, task: attributes_for(:task, deadline: DateTime.now - 2, content: "new content")
          task.reload
          expect(task.deadline).to be_within(1.day).of(DateTime.now + 2)
          expect(task.content).not_to eq("new content")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:task) { create(:task, assigner: @user, deadline: DateTime.now + 2, content: "original content") }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, user_id: @user.id, id: task.id }.to change{ Task.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, user_id: @user.id, id: task.id
        expect(response).to have_http_status(200)
      end
    end
  end 
end