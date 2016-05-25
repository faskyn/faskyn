require "rails_helper"

RSpec.describe ProductInvitation, type: :model do

  describe "model validations" do
    let(:product) { create(:product, :product_with_nested_attrs,) }
    let(:owner) { create(:user) }
    let(:product_user) { create(:product_user, product: product, user: owner, role: "owner") }
    let(:recipient) { create(:user) }

    it "has a valid factory" do
      expect(build_stubbed(:product_invitation, product: product, sender: owner, recipient: recipient, email: recipient.email)).to be_valid
    end
    
    it "is invalid without role" do
      expect(build_stubbed(:product_invitation, product: nil)).not_to be_valid
    end

    it "is invalid without user" do
      expect(build_stubbed(:product_invitation, sender: nil)).not_to be_valid
    end

    it "is invalid without product" do
      expect(build_stubbed(:product_invitation, recipient: nil)).not_to be_valid
    end

    it "is invalid without product" do
      expect(build_stubbed(:product_invitation, email: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:product) }
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:email) }
    
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:recipient) }
  end
end