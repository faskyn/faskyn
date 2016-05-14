require "rails_helper"

RSpec.describe ProductCustomer, type: :model do
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
end