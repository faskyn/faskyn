require "rails_helper"
#require "pry"

describe CommonMediasController do

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "GET requests" do
      let!(:user) { create(:user) }
      let!(:profile) { create(:profile, user: @user) }
      let!(:profile_2) { create(:profile, user: user) }
      let!(:conversation) { create(:conversation, sender: @user, recipient: user) }
      let!(:message) { create(:message_with_body, conversation: conversation, user: @user, created_at: DateTime.now - 6) }
      let!(:message_with_file) { create(:message_with_attachment, conversation: conversation, user: @user, created_at: DateTime.now - 4) }
      let!(:message_with_link) { create(:message_with_link, conversation: conversation, user: @user, created_at: DateTime.now - 2, link: ["www.faskyn.com"]) }
      
      context "get common medias" do
        before(:each) do
          get :common_medias, user_id: user.id
        end
          
        it "assigns instance variables" do
          expect(assigns(:user)).to eq(user)
          expect(assigns(:conversation)).to eq(conversation)
          expect(assigns(:messages)).to eq([message, message_with_file, message_with_link])
          expect(assigns(:message)).to be_a_new(Message)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :common_medias }
      end

      context "get common files" do
        before(:each) do
          xhr :get, :get_files, user_id: user.id
        end

        it "assigns instance variables" do
          expect(assigns(:user)).to eq(user)
          expect(assigns(:conversation)).to eq(conversation)
          expect(assigns(:common_files)).to eq([message_with_file])
        end

        it { is_expected.to respond_with 200 }
      end

      context "get common links" do
        before(:each) do
          xhr :get, :get_links, user_id: user.id
        end

        it "assigns instance variables" do
          expect(assigns(:user)).to eq(user)
          expect(assigns(:conversation)).to eq(conversation)
          expect(assigns(:message_links_pre)).to eq([message_with_link])
          expect(assigns(:message_links))
          expect(assigns(:common_links))
        end

        it { is_expected.to respond_with 200 }
      end
    end
  end
end