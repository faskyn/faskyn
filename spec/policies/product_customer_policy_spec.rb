require 'rails_helper'

describe ProductCustomerPolicy do
  subject { ProductCustomerPolicy }

  describe "policies belong to product customer" do
    let(:user) { build_stubbed(:user) }
    let(:other_user) { build_stubbed(:user) }
    let!(:profile) { build_stubbed(:profile, user: user) }
    let!(:other_profile) { build_stubbed(:profile, user: other_user) }
    let(:product) { build_stubbed(:product, :product_with_nested_attrs) }
    let!(:product_user) { build_stubbed(:product_user, user: user, product: product, role: "owner") }
    let(:user_without_profile) { build_stubbed(:user) }

    permissions :show? do

      it "only allows acces for people with profile" do
        expect(subject).to permit(user)
        expect(subject).to permit(other_user)
        expect(subject).to_not permit(user_without_profile)
      end
    end
  end

  describe "policies belong to review" do
    let(:owner) { create(:user) }
      let(:referencer) { create(:user) }
      let(:other_user) { build_stubbed(:user) }
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:product_user) { create(:product_user, user: owner, product: product, role: "owner") }
      let!(:product_customer) { create(:product_customer, product: product) }
      let!(:product_customer_user) { create(:product_customer_user, user: referencer, product_customer: product_customer) }

    permissions :create_reviews? do
      
      it "only allows access for product customer users" do
        expect(subject).to permit(referencer, product_customer)
        expect(subject).to_not permit(owner, product_customer)
        expect(subject).to_not permit(other_user, product_customer)
      end
    end

    permissions :destroy_review? do
      it "only allow access for product owner" do
        expect(subject).to permit(owner, product_customer)
        expect(subject).to_not permit(referencer, product_customer)
        expect(subject).to_not permit(other_user, product_customer)
      end
    end
  end
end