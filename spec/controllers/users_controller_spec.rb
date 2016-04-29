require "rails_helper"

describe UsersController do

  describe "when user is not logged in" do
    # before(:each) do
    #   get :index
    # end 
    it "GET index redirectes to login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET show redirects to login" do
      user = create(:user)
      get :show, id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end
    #it { is_expected.to redirect_to(new_user_session_path)}

  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    describe "GET index" do
      let!(:user_2) { create(:user) }
      let!(:profile) { create(:profile, user: @user) }
      let!(:profile_2) { create(:profile, user: user_2) }
      before(:each) do
        get :index
      end

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end
        
      it "assigns users" do
        get :index
        expect(assigns(:users)).to eq([user_2, @user])
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end

    describe "GET show" do
      let!(:user_2) { create(:user) }
      let!(:user_3) { create(:user) }
      let!(:profile) { create(:profile, user: @user) }
      let!(:profile_2) { create(:profile, user: user_2) }
      let!(:task) { create(:task, executor: user_2, assigner: @user, updated_at: DateTime.now - 2) }
      let!(:conversation) { create(:conversation, sender: user_2, recipient: @user) }
      let!(:message) { create(:message, conversation: conversation) }

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end

      context "when there is common task" do
        before(:each) do
          get :show, id: user_2
        end

        it "assigns all insctance vars" do
          expect(assigns(:user)).to eq(user_2)
          expect(assigns(:conversation)).to eq(conversation)
          expect(assigns(:tasks)).to eq([task])
          expect(assigns(:messages)).to eq([message])
          expect(assigns(:message)).to be_a_new(Message)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :show }
      end

      context "redirect to somewhere else" do
        before(:each) do
          get :show, id: user_3
        end

        it "assigns user" do
          expect(assigns(:user)).to eq(user_3)
        end

        it { is_expected.to respond_with 302 }
      end
    end
  end 
end