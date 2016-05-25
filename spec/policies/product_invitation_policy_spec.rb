require 'rails_helper'

describe ProductInvitationPolicy do
  subject { ProductInvitationPolicy }

  let(:owner) { build_stubbed(:user) }
  let(:invited_user) { build_stubbed(:user) }
  let(:profile) { build_stubbed(:profile, user: owner) }
  let(:other_profile) { build_stubbed(:profile, user: invited_user) }
  let(:product) { build_stubbed(:product, :product_with_nested_attrs) }
  let(:product_user) { build_stubbed(:product_user, user: owner, product: product, role: "owner") }
  let(:product_invitation) { build_stubbed(:product_invitation, 
    product: product, recipient: invited_user, sender: owner, email: invited_user.email) }

  permissions :accept? do

    it "only allows access for recipient" do
      expect(subject).to permit(invited_user, product_invitation)
      expect(subject).to_not permit(owner, product_invitation)
    end
  end

  permissions :destroy? do

    it "allows accss for recipient and sender" do
      expect(subject).to permit(invited_user, product_invitation)
      expect(subject).to permit(owner, product_invitation)
    end
  end
end