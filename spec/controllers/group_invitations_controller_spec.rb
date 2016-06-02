require "rails_helper"

describe GroupInvitationsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "PATCH accept" do
      let(:sender) { create(:user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product: product, role: "owner", user: sender) }
      let!(:group_invitation) { create(:group_invitation, group_invitable: product, recipient: @user,
          sender: sender, email: @user.email) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_path(product)
      end

      it "assigns group invitation" do
        patch :accept, id: group_invitation.id, group_invitation: attributes_for(:group_invitation)
        expect(assigns(:group_invitation)).to eq(group_invitation)
      end

      it "updates group invitation" do
        patch :accept, id: group_invitation.id, group_invitation: attributes_for(:group_invitation, accepted: true)
        group_invitation.reload
        expect(group_invitation.accepted).to eq(true)
      end

      it "creates product user" do
        expect{ patch :accept, id: group_invitation.id, 
          group_invitation: attributes_for(:group_invitation, accepted: true) }.to change{ ProductUser.count }.by(1)
      end

      it "creates notification" do
        expect{ patch :accept, id: group_invitation.id, 
          group_invitation: attributes_for(:group_invitation, accepted: true) }.to change{ Notification.count }.by(1)
      end
    end

    describe "DELETE destroy" do
      let(:sender) { create(:user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product: product, role: "owner", user: sender) }
      let!(:group_invitation) { create(:group_invitation, group_invitable: product,
        sender: sender, recipient: @user, email: @user.email) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end
      subject(:destroy_action) { delete :destroy, id: group_invitation.id }

      it "destroys the invitation" do
        expect { destroy_action }.to change{ GroupInvitation.count }.by(-1)
      end

      it "redirects to referer" do
        destroy_action
        expect(response).to redirect_to product_product_owner_panels_path(product)
        expect(controller).to set_flash[:notice].to("Invitation got deleted!")
      end
    end
  end
end
