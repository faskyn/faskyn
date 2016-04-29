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

    describe "GET requests" do
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

      context "with valid attributes" do
        subject(:create_action) { post :create, user_id: @user.id, profile: attributes_for(:profile, user: @user) }

        it "saves the new profile in the db" do
          expect{ create_action }.to change{ Profile.count }.by(1)
        end

        it "redirects to add socials page" do 
          expect(create_action).to redirect_to add_socials_user_profile_path(@user)
        end
      end

      context "with invalid attributes db" do
        subject(:create_action) { post :create, user_id: @user.id, 
                    profile: attributes_for(:profile, user: @user, first_name: nil) }
        
        it "doesn't save the profile in the db" do
          expect { create_action }.to_not change{ Profile.count }
        end

        it "renders new template" do 
          expect(create_action).to render_template :new
        end
      end
    end

    describe "PUT update" do
      let!(:profile) { create(:profile, user: @user, first_name: "Sean", last_name: "Magyar") }

      context "with valid attributes" do

        it "assigns the profile" do
          patch :update, user_id: @user.id, id: profile.id, profile: attributes_for(:profile)
          expect(assigns(:profile)).to eq(profile)
        end

        it "changes the attributes" do
          patch :update, user_id: @user.id, id: profile.id, profile: attributes_for(:profile, first_name: "Sean", last_name: "Hun")
          profile.reload
          expect(profile.first_name).to eq("Sean")
          expect(profile.last_name).to eq("Hun")
        end

        it "redirects to profile page and shows flash" do
          patch :update, user_id: @user.id, id: profile.id, profile: attributes_for(:profile)
          expect(response).to redirect_to user_profile_path(@user)
          expect(controller).to set_flash[:notice].to("Profile updated!")
        end
      end

      context "with invalid attributes" do
        subject(:invalid_update_action) { patch :update, user_id: @user.id, id: profile.id, profile: attributes_for(:profile, first_name: nil, last_name: "Hun") }

        it "doesn't change the attributes" do
          invalid_update_action
          profile.reload
          expect(profile.first_name).to eq("Sean")
          expect(profile.last_name).not_to eq("Hun")
        end

        it "renders the edit template" do
          #patch :update, user_id: @user.id, id: profile.id, profile: attributes_for(:profile, first_name: nil, last_name: "Hun")
          #expect(response).to render_template :edit
          expect(invalid_update_action).to render_template :edit
        end
      end
    end 
  end 
end