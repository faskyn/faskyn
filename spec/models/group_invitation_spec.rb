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

  describe "scopes" do
    let(:referencer) { create(:user) }
    let(:member) { create(:user) }
    let(:owner) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, product: product, role: "owner", user: owner) }
    let(:product_customer) { create(:product_customer, product: product) }
    let!(:accepted_customer_group_invitation) { create(:group_invitation, group_invitable: product_customer, recipient: referencer, sender: owner, email: referencer.email ,accepted: true) }
    let!(:pending_product_group_invitation) { create(:group_invitation, group_invitable: product, recipient: member, sender: owner, email: member.email) }

    it "pending users" do
      expect(product.group_invitations.pending_user(member)).to eq([pending_product_group_invitation])
      expect(product.group_invitations.pending_user(member)).to_not include(accepted_customer_group_invitation)
    end

    it "belonging to product user" do
      expect(product.group_invitations.belonging_to_product_user(member)).to eq([pending_product_group_invitation])
      expect(product.group_invitations.belonging_to_product_user(member)).to_not include(accepted_customer_group_invitation)
    end

    it "belonging to product customer user" do
      expect(product_customer.group_invitations.belonging_to_product_customer_user(referencer)).to eq([accepted_customer_group_invitation])
      expect(product_customer.group_invitations.belonging_to_product_customer_user(referencer)).to_not include(pending_product_group_invitation)
    end
  end
end