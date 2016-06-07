require "rails_helper"

describe ReviewsController do

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "GET edit" do
      let(:product) { create(:product, :product_with_nested_attrs) }
      let(:product_customer) { create(:product_customer, product: product) }
      let(:product_customer_user) {create(:product_customer_user, user: @user, product_customer: product_customer) }
      let!(:review) { create(:review, user: @user, product_customer: product_customer) }
      before(:each) do
        xhr :get, :edit, id: review.id
      end

      it "assigns post" do
        expect(assigns(:review)).to eq(review)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :edit }
    end

    describe "POST create" do
      let!(:profile) { create(:profile, user: @user) }
      let(:user) { create(:user) }
      let!(:product_user) { create(:product_user, user: user, product: product, role: "owner") }
      let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:product_customer) { create(:product_customer, product: product) }

      context "with valid attributes" do
        subject(:create_action) { xhr :post, :create, product_customer_id: product_customer.id, review: attributes_for(:review, user: @user) }

        it "saves the new task in the db" do
          expect{ create_action }.to change{ Review.count }.by(1)
        end

        it "sends notification" do
          expect{ create_action }.to change{ Notification.count }.by(1)
        end

        it 'triggers review writer job' do
          expect{ create_action }.to change{ ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
        end

        it "responds with success" do
          create_action
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { xhr :post, :create, product_customer_id: product_customer.id, review: attributes_for(:review, user: @user, body: "") }

        it "doesn't save the new product in the db" do
          expect{ create_action }.to_not change{ Review.count }
        end
      end
    end

    describe "PATCH update" do
      let!(:profile) { create(:profile, user: @user) }
      let(:user) {create(:user) }
      let!(:product_user) { create(:product_user, user: user, product: product, role: "owner") }
      let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: @user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let(:product_customer) { create(:product_customer, product: product) }
      let!(:review) { create(:review, user: @user, product_customer: product_customer, body: "original body") }
      
      context "with valid attributes" do

        it "assigns the post and the new comment and reply" do
          xhr :patch, :update, id: review.id, review: attributes_for(:review)
          expect(assigns(:review)).to eq(review)
        end

        it "changes the attributes" do
          xhr :patch, :update, id: review.id, review: attributes_for(:review, body: "new body")
          review.reload
          expect(review.body).to eq("new body")
        end

        it "responds with success" do
          xhr :patch, :update, id: review.id, review: attributes_for(:review)
          expect(response).to have_http_status(200)
        end
      end

      context "with invalid attributes" do

        it "doesn't change the attributes" do
          xhr :patch, :update, id: review.id, review: attributes_for(:review, body: "")
          review.reload
          expect(review.body).to eq("original body")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:profile) { create(:profile, user: @user) }
      let(:user) {create(:user) }
      let!(:product_user) { create(:product_user, user: @user, product: product, role: "owner") }
      let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let(:product_customer) { create(:product_customer, product: product) }
      let!(:review) { create(:review, user: user, product_customer: product_customer) }

      it "destroys the product" do
        expect{ xhr :delete, :destroy, id: review.id }.to change{ Review.count }.by(-1)
      end

      it "responds with success" do
        xhr :delete, :destroy, id: review.id
        expect(response).to have_http_status(200)
      end
    end
  end
end