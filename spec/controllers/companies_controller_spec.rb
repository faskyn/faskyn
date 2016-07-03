require "rails_helper"

describe CompaniesController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "GET requests when there is no company yet" do
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs, owner: @user) }

      context "GET new" do
        before do
          get :new, product_id: product.id
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :new }
      end
    end

    describe "GET requests when there is already a company" do
      let!(:profile) { create(:profile, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs, owner: @user) }
      let!(:company) { create(:company, product: product) }

      context "GET show" do
        before do
          get :show, product_id: product.id
        end

        it "assigns product and company" do
          expect(assigns(:product)).to eq(product)
          expect(assigns(:company)).to eq(company)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :show }
      end

      context "GET edit" do
        before do
          get :edit, product_id: product.id
        end

        it "assigns profile" do
          expect(assigns(:product)).to eq(product)
          expect(assigns(:company)).to eq(company)
        end

        it { is_expected.to respond_with 200 }
        it { is_expected.to render_template :edit }
      end

      context "GET new when there is already a company" do
        before do
          get :new, product_id: product.id
        end

        it "assigns profile" do
          expect(assigns(:product)).to eq(product)
        end

        it { is_expected.to respond_with 302 }
      end
    end

    describe "POST create" do
      let!(:profile) { create(:profile, user: @user) }
      let!(:product) { create(:product, :product_with_nested_attrs, owner: @user) }

      before(:each) do
        if product.company.present?
          product.company.destroy
        end
        request.env["HTTP_REFERER"] = new_product_company_path(product)
      end

      context "with vaild attributes" do
        subject(:create_action) { post :create, product_id: product.id, company: attributes_for(:company, product: product) } 

        it "saves the new company in the db" do
          expect{ create_action }.to change{ Company.count }.by(1)
        end

        it "redirects to back and shows the flash" do
          create_action
          expect(response).to redirect_to product_company_path(product)
          expect(controller).to set_flash[:notice].to("Company successfully created!")
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { post :create, product_id: product.id, company: attributes_for(:company, product: product, location: nil) } 

        it "doesn't save the new company in the db" do
          expect{ create_action }.to_not change{ Company.count }
        end

        it "renders new template" do 
          expect(create_action).to render_template :new
        end
      end
    end

    describe "PUT update" do
      let(:product ) { create(:product, :product_with_nested_attrs, owner: @user) }
      let!(:company) { create(:company, product: product, name: "Great Inc", location: "Budapest, HU") }

      context "with valid attributes" do
        it "assigns instance variables" do
          patch :update, product_id: product.id, id: company.id, company: attributes_for(:company)
          expect(assigns(:product)).to eq(product)
          expect(assigns(:company)).to eq(company)
        end

        it "changes the attributes" do
          patch :update, product_id: product.id, id: company.id, company: attributes_for(:company, name: "Faskyn Inc", location: "San Francisco, CA")
          company.reload
          expect(company.name).to eq("Faskyn Inc")
          expect(company.location).to eq("San Francisco, CA")
        end

        it "redirects to profile page and shows flash" do
          patch :update, product_id: product.id, id: company.id, company: attributes_for(:company)
          expect(response).to redirect_to product_company_path(product)
          expect(controller).to set_flash[:notice].to("Company successfully updated!")
        end
      end

      context "with invalid attributes" do
        subject(:invalid_update_action) { patch :update, product_id: product.id, id: company.id, company: attributes_for(:company, name: nil, location: "Berlin, GE") }

        it "doesn't change the attributes" do
          invalid_update_action
          company.reload
          expect(company.name).to eq("Great Inc")
          expect(company.location).to_not eq("Berlin, GE")
        end

        it "renders the edit template" do
          expect(invalid_update_action).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      let!(:product) { create(:product, :product_with_nested_attrs, owner: @user) }
      let!(:company) { create(:company, product: product) }
      subject(:destroy_action) { delete :destroy, product_id: product.id, id: company.id }

      it "destroys the product" do
        expect{ destroy_action }.to change{ Company.count }.by(-1)
      end

      it "redirects to products index page" do
        destroy_action
        expect(response).to redirect_to product_path(product)
        expect(controller).to set_flash[:notice].to("Company got deleted!")
      end
    end
  end
end