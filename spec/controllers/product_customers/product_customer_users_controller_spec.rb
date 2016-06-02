require "rails_helper"

describe ProductCustomers::ProductCustomerUsersController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "DELETE destroy" do
      let(:referencer_user) { create(:user) }
      let!(:referencer_profile) { create(:profile, user: referencer_user) }
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: @user.id) }
      let(:product_customer) { create(:product_customer, product: product) }
      let!(:referencer) { create(:product_customer_user, product_customer: product_customer, user: referencer_user) }
      subject(:destroy_action) { delete :destroy, product_customer_id: product_customer.id, id: referencer.id }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end

      it "destroys the product customer user" do
        expect{ destroy_action }.to change{ ProductCustomerUser.count }.by(-1)
      end

      it "redirects to products owner panel page" do
        destroy_action
        expect(response).to redirect_to product_product_owner_panels_path(product)
        expect(controller).to set_flash[:notice].to("User removed from product referencers!")
      end
    end
  end
end