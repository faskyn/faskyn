require "rails_helper"

describe PostsController do

  describe "when user is not logged in" do

    it "GET index redirectes to login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    context "GET index" do
      before(:each) do
        get :index
      end
      let!(:profile) { create(:profile, user: @user) }
      let!(:post) { create(:post, user: @user) }

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end
        
      it "assigns users" do
        get :index
        expect(assigns(:posts)).to eq([post])
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end
  end
end