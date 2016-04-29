require "rails_helper"
# require "pry"

describe SocialsController do

  describe "when user is logged in" do
    before(:each) do
      login_user
    end
  
    describe "POST create" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:social) { create(:social, profile: profile) }

      it "creates or updates social" do
        post :create
        expect(assigns(:profile)).to eq(profile)
        #expect(assigns(:profile)).to eq(receive)
        #expect(@profile).to receive(:find_or_create_from_auth_hash)
      end

      it "testing socials"
    end
  end
end