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

    describe "GET index" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      before(:each) do
        get :index
      end
        
      it "assigns products" do
        expect(assigns(:products)).to eq([product])
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :index }
    end

    describe "GET own_products" do
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

    describe "GET show" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user) }
      before(:each) do
        get :show, id: product
      end
      
      it "assigns products" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:product).industry_products.size).to eq(1)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :show }
    end

    describe "GET new" do
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

    describe "GET edit" do
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

    describe "POST create" do

      context "with valid attributes" do
        let!(:profile) { create(:profile, user: @user) }
        let!(:industry) { create(:industry) }
        let!(:attrs) { attributes_for(:product, user_id: @user.id, industry_ids: [ industry.id ]).merge(
            product_customers_attributes: [attributes_for(:product_customer)]
          )}
        subject(:create_action) { post :create, product: attrs }
        # let!(:product) { build(:product, :product_with_nested_attrs, user: @user) }

        it "saves the new product in the db" do
          expect{ create_action }.to change{ Product.count }.by(1)
        end

        it "redirects to product page and shows the flash" do
          create_action
          expect(response).to redirect_to product_path(Product.last)
          expect(controller).to set_flash[:notice].to("Product got created!")
        end
      end

      context "with invalid attributes" do
        let!(:profile) { create(:profile, user: @user) }
        let!(:industry) { create(:industry) }
        let!(:attrs) { attributes_for(:product, user_id: @user.id, name: nil, industry_ids: [ industry.id ]) }
        subject(:create_action) { post :create, product: attrs }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ Product.count }
        end

        it "renders new action" do
          expect(create_action).to render_template :new
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:industry) { create(:industry) }
      # let!(:product) { create(:product, user_id: @user.id, industry_ids: [ industry.id ]).merge(
      #     product_usecases_attributes: [attributes_for(:product_usecase)]
      #   ) }
      let!(:product) { create(:product, :product_with_nested_attrs, user_id: @user.id, name: "Test Product", description: "Original Description") }

      context "with valid attributes" do

        it "assigns the profile" do
          patch :update, id: product.id, product: attributes_for(:product)
          expect(assigns(:product)).to eq(product)
        end

        it "changes the attributes" do
          patch :update, id: product.id, product: attributes_for(:product, name: "Test Product", description: "Test Product Description")
          product.reload
          expect(product.name).to eq("Test Product")
          expect(product.description).to eq("Test Product Description")
        end

        it "redirects to product page and shows the flash" do
          patch :update, id: product.id, product: attributes_for(:product)
          expect(response).to redirect_to product_path(product)
          expect(controller).to set_flash[:notice].to("Product was successfully updated!")
        end
      end

      context "with invalid attributes" do
        subject(:invalid_update_action) { patch :update, id: product.id, product: attributes_for(:product, name: nil, description: "Test Product Description") }

        it "doesn't change the attributes" do
          invalid_update_action
          product.reload
          expect(product.name).to eq("Test Product")
          expect(profile.last_name).not_to eq("Test Product Description")
        end

        it "renders the edit template" do
          expect(invalid_update_action).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      let!(:product) { create(:product, :product_with_nested_attrs, user_id: @user.id) }
      subject(:destroy_action) { delete :destroy, id: product.id }

      it "destroys the product" do
        expect{ destroy_action }.to change{ Product.count }.by(-1)
      end

      it "redirects to products index page" do
        destroy_action
        expect(response).to redirect_to products_path
        expect(controller).to set_flash[:notice].to("Product got deleted!")
      end
    end
  end
end