require "rails_helper"

RSpec.describe ProductCustomer, type: :model do

  describe "model validations" do

    let(:product) { create(:product, :product_with_nested_attrs) }

    it "has a valid factory" do
      expect(build_stubbed(:product_customer, product: product)).to be_valid
    end
    
    it "is invalid without example" do
      expect(build_stubbed(:product_customer, customer: nil)).not_to be_valid
    end

    it "is invalid without detail" do
      expect(build_stubbed(:product_customer, usage: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:customer).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:usage).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:customer).is_at_most(80).with_message(/can't be longer than 80 characters/) }
    it { is_expected.to validate_presence_of(:product) }
    
    it { is_expected.to belong_to(:product).touch }
    it { is_expected.to have_many(:comments) }
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, user: user, product: product, role: "owner") }
    let!(:product_customer) { create(:product_customer, product: product) }

    it "returns product user" do
      expect(product_customer.owner).to eq(user)
    end
  end
end