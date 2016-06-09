require "rails_helper"

describe Products::ProductOwnerPanelsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "GET index" do
      let(:referencer_user) { create(:user) }
      let!(:referencer_profile) { create(:profile, user: referencer_user) }
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs, owner: @user) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: @user.id) }
      let(:product_customer) { create(:product_customer, product: product) }
      let!(:referencer) { create(:product_customer_user, product_customer: product_customer, user: referencer_user) }
      before(:each) do
        get :index, product_id: product.id
      end

      it "assigns instance variables" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:product_users)).to include(owner)
        expect(assigns(:product_customer_users)).to include(referencer)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end

  end
end