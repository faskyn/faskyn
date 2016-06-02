require "rails_helper"

RSpec.describe GroupInvitation, type: :model do

  describe "model validations" do
    let(:group_invitable) { create(:product, :product_with_nested_attrs,) }
    let(:owner) { create(:user) }
    let(:product_user) { create(:product_user, product: product, user: owner, role: "owner") }
    let(:recipient) { create(:user) }

    it "has a valid factory" do
      expect(build_stubbed(:group_invitation, recipient: recipient, sender: owner, 
        group_invitable_id: group_invitable.id, group_invitable_type: "Product", email: recipient.email)).to be_valid
    end
    
    it "is invalid without role" do
      expect(build_stubbed(:group_invitation, group_invitable_id: nil)).not_to be_valid
    end

    it "is invalid without role" do
      expect(build_stubbed(:group_invitation, group_invitable_type: nil)).not_to be_valid
    end

    it "is invalid without user" do
      expect(build_stubbed(:group_invitation, sender: nil)).not_to be_valid
    end

    it "is invalid without product" do
      expect(build_stubbed(:group_invitation, recipient: nil)).not_to be_valid
    end

    it "is invalid without product" do
      expect(build_stubbed(:group_invitation, email: nil)).not_to be_valid
    end
    
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:group_invitable_id) }
    it { is_expected.to validate_presence_of(:group_invitable_type) }
    it { is_expected.to validate_presence_of(:email) }
    
    it { is_expected.to belong_to(:recipient) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:group_invitable) }
  end
end