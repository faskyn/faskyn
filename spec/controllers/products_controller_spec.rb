require "rails_helper"
#require "pry"

describe ProductsController do

  describe "when user is not logged in" do

    it "GET index redirects to login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    context "GET index" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      before(:each) do
        get :index
      end
        
      it "assigns products" do
        get :index
        expect(assigns(:products)).to eq([product])
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end

    context "GET own_products" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:user) { create(:user) }
      let!(:profile_other) { create(:profile, user: user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      let!(:product_other) { create(:product, :product_with_nested_attrs, user: user) }
      before(:each) do
        get :own_products, user_id: @user.id
      end

      it "assigns own products" do
        expect(assigns(:user)).to eq(@user)
        expect(assigns(:products)).to eq([product])
        expect(assigns(:products)).not_to include(product_other)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :own_products }
    end

    context "GET show" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      before(:each) do
        get :show, id: product
      end
      
      it "assigns products" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:product).product_usecases.size).to eq(1)
        expect(assigns(:product).product_features.size).to eq(1)
        expect(assigns(:product).product_competitions.size).to eq(1)
        expect(assigns(:product).industry_products.size).to eq(1)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :show }
    end

    context "GET new" do
      let!(:profile) { create(:profile, user: @user) }
      before(:each) do
        get :new
      end

      it "assigns product" do
        expect(assigns(:product)).to be_a_new(Product)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :new }
    end

    context "GET edit" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      before(:each) do
        get :edit, id: product.id
      end

      it "assigns product" do
        expect(assigns(:product)).to eq(product)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :edit }
    end

    # context "POST create" do
    #   context "with valid attributes" do
    #     let!(:profile) { create(:profile, user: @user) }
    #     # let!(:product) { build(:product, :product_with_nested_attrs, user: @user) }

    #     it "saves the new product in the db" do
    #       product_attrs = attributes_for(:product, :product_for_create_action, user: @user)
    #       expect{ post :create, product: product_attrs }.to change{ Product.count }.by(1)
    #     end

    #     it { is_expected.to redirect_to product_path(Product.last) }
    #     it { is_expected.to set_flash(:notice).to('Product got created!') }
    #   end

    #   context "with invalid attributes" do
    #   end
    # end
  end
end