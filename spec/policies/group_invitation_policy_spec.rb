require 'rails_helper'

describe GroupInvitationPolicy do
  subject { GroupInvitationPolicy }

  let(:owner) { build_stubbed(:user) }
  let(:invited_user) { build_stubbed(:user) }
  let(:profile) { build_stubbed(:profile, user: owner) }
  let(:other_profile) { build_stubbed(:profile, user: invited_user) }
  let(:product) { build_stubbed(:product, :product_with_nested_attrs) }
  let(:product_user) { build_stubbed(:product_user, user: owner, product: product, role: "owner") }
  let(:group_invitation) { build_stubbed(:group_invitation, 
    group_invitable: product, recipient: invited_user, sender: owner, email: invited_user.email) }

  permissions :accept? do

    it "only allows access for recipient" do
      expect(subject).to permit(invited_user, group_invitation)
      expect(subject).to_not permit(owner, group_invitation)
    end
  end

  permissions :destroy? do

    it "allows accss for recipient and sender" do
      expect(subject).to permit(invited_user, group_invitation)
      expect(subject).to permit(owner, group_invitation)
    end
  end
end