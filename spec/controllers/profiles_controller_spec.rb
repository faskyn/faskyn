require "rails_helper"
#require "pry"

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
      before do
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
      before do
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

    context "GET new" do
      before do
        get :new, user_id: @user.id
      end

      it "assigns profile" do
        expect(assigns(:profile)).to be_a_new(Profile)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :new }
    end
  end

  describe "POST create" do
    before(:each) do
      login_user
    end
    context "with valid attributes" do

      it "saves the new profile in the db" do
        @user.profile.destroy
        expect{ post :create, user_id: @user.id, profile: FactoryGirl.attributes_for(:profile, user: @user) }.to change(Profile, :count).by(1)
      end

      before do
        post :create, user_id: @user.id, profile: attributes_for(:profile, user: @user)
      end

      it { is_expected.to redirect_to add_socials_user_profile_path(@user) }
    end

    context "with invalid attributes" do
    end
  end  
end