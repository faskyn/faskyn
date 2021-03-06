require "rails_helper"

RSpec.describe ProductCustomer, type: :model do

  describe "model validations" do

    let(:product) { create(:product, :product_with_nested_attrs) }

    it "has a valid factory" do
      expect(build_stubbed(:product_customer, product: product)).to be_valid
    end
    
    it "is invalid without example" do
      expect(build_stubbed(:product_customer, product: product, customer: nil)).not_to be_valid
    end

    it "is invalid without detail" do
      expect(build_stubbed(:product_customer, product: product, usage: nil)).not_to be_valid
    end

    it "is invalid without website" do
      expect(build_stubbed(:product_customer, product: product, website: nil)).not_to be_valid
    end

    it "is invalid with wrong website format" do
      expect(build_stubbed(:product_customer, product: product, website: "example")).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:customer).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:usage).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:website).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:customer).is_at_most(80).with_message(/can't be longer than 80 characters/) }
    it { is_expected.to validate_presence_of(:product) }
    
    it { is_expected.to belong_to(:product).touch }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:product_customer_users) }
    it { is_expected.to have_many(:users).through(:product_customer_users) }
    it { is_expected.to have_many(:reviews) }
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs, owner: user) }
    let!(:product_customer) { create(:product_customer, product: product) }

    it "returns product user" do
      expect(product_customer.owner).to eq(user)
    end
  end
end