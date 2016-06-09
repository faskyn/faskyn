require "rails_helper"

describe Products::ProductUsersController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "DELETE destroy" do
      let(:member) { create(:user) }
      let(:other_profile) { create(:profile, user: member) }
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs, owner: @user) }
      let!(:product_user) { create(:product_user, product: product, user: member, role: "member") }
      let!(:group_invitation) { create(:group_invitation, sender: @user, recipient: member, group_invitable: product, email: member.email, accepted: true) }
      subject(:destroy_action) { delete :destroy, product_id: product.id, id: product_user.id }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end

      it "destroys the product user" do
        expect{ destroy_action }.to change{ ProductUser.count }.by(-1)
      end

      it "destroys all the invitations belonging to the product user" do
        expect{ destroy_action }.to change{ GroupInvitation.count }.by(-1)
      end

      it "redirects to products owner panel page" do
        destroy_action
        expect(response).to redirect_to product_product_owner_panels_path(product)
        expect(controller).to set_flash[:notice].to("User removed from product members!")
      end
    end
  end
end