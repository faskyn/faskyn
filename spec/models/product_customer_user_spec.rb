require "rails_helper"

RSpec.describe ProductCustomerUser, type: :model do

  describe "model validations" do
    let!(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_customer) { create(:product_customer, product: product) }

    it "has a valid factory" do
      expect(build_stubbed(:product_customer_user, product_customer: product_customer)).to be_valid
    end
    
    it "is invalid without user" do
      expect(build_stubbed(:product_customer_user, user: nil)).not_to be_valid
    end

    it "is invalid without product customer" do
      expect(build_stubbed(:product_customer_user, product_customer: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:product_customer) }
    
    it { is_expected.to belong_to(:product_customer).touch }
    it { is_expected.to belong_to(:user) }
  end
end