require 'rails_helper'

describe ApplicationController do

  describe "when user is logged in" do
    before(:each) do
      login_user
    end

    context "set_sidebar_users" do
      let!(:profile) { create(:profile, user: @user, created_at: DateTime.now - 2) }
      let!(:user) { create(:user) }
      let!(:profile_older) { create(:profile, user: user, created_at: DateTime.now - 4) }

      it "assigns sidebar profiles" do
        expect(subject.set_sidebar_users).to eq([profile, profile_older])
      end
    end

    context "set_sidebar_products" do
      let!(:product) { create(:product, :product_with_nested_attrs, user: @user, created_at: DateTime.now - 6, updated_at: DateTime.now - 2) }
      let!(:product_older) { create(:product, :product_with_nested_attrs, user: @user, created_at: DateTime.now - 6, updated_at: DateTime.now - 4) }

      it "assigns sidebar profiles" do
        expect(subject.set_sidebar_products).to include(product, product_older)
      end
    end
  end
end