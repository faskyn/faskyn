require "rails_helper"

describe ProfilesController do

  describe "when user is not logged in" do
    let(:user) { create(:user) }
    let(:profile) { create(:profile, user: user) }

    it "GET show redirects to login" do
      get :show, user_id: user.id, id: profile.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET edit redirects to login" do
      get :edit, user_id: user.id, id: profile.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end
    let!(:profile) { create(:profile, user: @user) }
    let!(:social_twitter) { create(:social, provider: "twitter", profile: profile) }
    let!(:social_linkedin) { create(:social, provider: "linkedin", profile: profile) }

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    context "GET show" do
      before(:each) do
        get :show, user_id: @user.id
      end

      it "assigns profile" do
        expect(assigns(:profile)).to eq(profile)
        expect(assigns(:twitter)).to eq(social_twitter)
        expect(assigns(:linkedin)).to eq(social_linkedin)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :show }
    end

    context "GET edit" do
      before(:each) do
        get :edit, user_id: @user.id
      end

      it "assigns profile" do
        expect(assigns(:profile)).to eq(profile)
        expect(assigns(:twitter)).to eq(social_twitter)
        expect(assigns(:linkedin)).to eq(social_linkedin)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :edit }
    end
  end
end