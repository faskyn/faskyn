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
      let(:other_profile) { create(:profile, user: user) }
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: @user.id) }
      let!(:member) { create(:product_user, product_id: product.id, role: "member") }
      subject(:destroy_action) { delete :destroy, product_id: product.id, id: member.id }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end

      it "destroys the product user" do
        expect{ destroy_action }.to change{ ProductUser.count }.by(-1)
      end

      it "redirects to products owner panel page" do
        destroy_action
        expect(response).to redirect_to product_product_owner_panels_path(product)
        expect(controller).to set_flash[:notice].to("User removed from product members!")
      end
    end
  end
end