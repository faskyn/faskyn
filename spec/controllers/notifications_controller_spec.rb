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
        expect(assigns(:chat_notifications)).to_not include(outgoing_chat_notification, other_notification)
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
        expect(assigns(:other_notifications)).to_not include(outgoing_other_notification, chat_notification)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :other_notifications }
    end

    context "GET chat_notifications_dropdown" do
      let!(:not_checked_chat_notification) { create(:notification, sender: user, recipient: @user, notifiable_type: "Message", checked_at: nil) }
      before(:each) do
        get :chat_notifications_dropdown, user_id: @user.id, format: :json
      end

      it "assigns user's chat notifications" do
        expect(assigns(:chat_notifications)).to eq([not_checked_chat_notification])
      end

      it "doesn't assign user's other and checked notifications" do
        expect(assigns(:chat_notifications)).to_not include(chat_notification, other_notification)
      end

      it { is_expected.to respond_with 200 }
    end

    context "GET other_notifications_dropdown" do
      let!(:not_checked_other_notification) { create(:notification, sender: user, recipient: @user, notifiable_type: "Task", checked_at: nil) }
      before(:each) do
        get :other_notifications_dropdown, user_id: @user.id, format: :json
      end

      it "assigns user's other notifications" do
        expect(assigns(:other_notifications)).to eq([not_checked_other_notification])
      end

      it "doesn't assign user's other and checked notifications" do
        expect(assigns(:other_notifications)).to_not include(other_notification, chat_notification)
      end

      it { is_expected.to respond_with 200 }
    end

    context "GET checking_decreasing" do
      let!(:post) { create(:post, user: @user,) }
      let!(:notification) { create(:notification, sender: user, recipient: @user, notifiable_type: "Post", notifiable_id: post.id, action: "commented") }

      # it "invokes decreasing_comment_notification_number on current user" do
      #   expect(@user).to receive(:decreasing_comment_notification_number).with("Post", post.id)
      #   get :checking_decreasing, user_id: @user.id, notifiable_type: notification.notifiable_type, notifiable_id: notification.notifiable_id
      # end

      it "redirects to notifiable" do
        get :checking_decreasing, user_id: @user.id, notification: notification
        expect(response).to redirect_to "/posts#post_#{notification.notifiable_id}"
      end
    end
  end

  describe "notifications redirection" do
    before(:each) do
      login_user
    end
    
    let(:product) { create(:product, :product_with_nested_attrs, created_at: DateTime.now - 6, updated_at: DateTime.now - 2) }
    let!(:product_customer) { create(:product_customer, product: product) }

    it "returns product owner panels path for accepted action" do
      notification = create(:notification, notifiable_type: "Product", notifiable_id: product.id, action: "accepted")
      expect(subject.notification_redirection_path(notification)).to eq("/products/#{product.id}/product_owner_panels")
    end

    it "returns product customer path for commented action" do
      notification = create(:notification, notifiable_type: "ProductCustomer", notifiable_id: product_customer.id, action: "commented")
      expect(subject.notification_redirection_path(notification)).to eq("/products/#{product.id}/product_customers/#{product_customer.id}#comment-panel")
    end

    it "returns product path for product customer invited action" do
      notification = create(:notification, notifiable_type: "ProductCustomer", notifiable_id: product_customer.id, action: "invited")
      expect(subject.notification_redirection_path(notification)).to eq("/products/#{product.id}/product_customers/#{product_customer.id}")
    end
  end
end