require "rails_helper"

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
  
    describe "collections" do

      before(:each) do
        login_user
      end
      let!(:user) { create(:user) }
      let!(:assigned_task) { create(:task, assigner: @user, executor: user, deadline: DateTime.now + 2) }
      let!(:executed_task) { create(:task, executor: @user, assigner: user, deadline: DateTime.now + 3) }
      let!(:completed_task) { create(:task, executor: @user, assigner: user, completed_at: DateTime.now - 2) } 
      let!(:profile) { create(:profile, user: @user) }
      let!(:profile_2) { create(:profile, user: user) }
      let!(:other_task) { create(:task) }

      context "GET index" do
        before(:each) do
          get :index, user_id: @user.id
        end

        it "should have a current_user" do
          expect(subject.current_user).to_not eq(nil)
        end
        
        it "assigns user's tasks" do
          expect(assigns(:tasks)).to eq([executed_task, assigned_task])
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
    end

    describe "GET edit"
    describe "POST create"
    describe "PUT update"
    describe "DELETE destroy"
  end 
end