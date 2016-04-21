require "rails_helper"

describe NotificationsController do

  describe "when user is not logged in" do
    let(:user) { create(:user) }
    let(:notification) { create(:profile, recipient: user) }

    it "GET chat_notifications redirects to login" do
      get :chat_notifications, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET other_notifications redirects to login" do
      get :other_notifications, user_id: user.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end
    let!(:user) { create(:user) }
    let!(:profile) { create(:profile, user: @user) }
    let!(:profile_2) { create(:profile, user: user) }
    let!(:chat_notification) { create(:notification, sender: user, recipient: @user, notifiable_type: "Message") }
    let!(:other_notification) { create(:notification, sender: user, recipient: @user, notifiable_type: "Task") }
    let!(:outgoing_chat_notification) { create(:notification, recipient: user, sender: @user, notifiable_type: "Message") }
    let!(:outgoing_other_notification) { create(:notification, recipient: user, sender: @user, notifiable_type: "Task") }

    context "GET chat_notifications" do
      before(:each) do
        get :chat_notifications, user_id: @user.id
      end

      it "assigns user's chat notifications" do
        expect(assigns(:chat_notifications)).to eq([chat_notification])
      end

      it "doesn't assign user's outgoing and other notifications" do
        expect(assigns(:chat_notifications)).to_not include(outgoing_chat_notification)
        expect(assigns(:chat_notifications)).to_not include(other_notification)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :chat_notifications }
    end

    context "GET other_notifications" do
      before(:each) do
        get :other_notifications, user_id: @user.id
      end

      it "assigns user's chat notifications" do
        expect(assigns(:other_notifications)).to eq([other_notification])
      end

      it "doesn't assign user's outgoing and other notifications" do
        expect(assigns(:other_notifications)).to_not include(outgoing_other_notification)
        expect(assigns(:other_notifications)).to_not include(chat_notification)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :other_notifications }
    end
  end
end