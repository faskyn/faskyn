require 'rails_helper'

describe ProductPolicy do
  subject { ProductPolicy }

  describe "policies belongs to product" do
    let(:user) { create(:user) }
    let(:other_user) { build_stubbed(:user) }
    let!(:profile) { build_stubbed(:profile, user: user) }
    let!(:other_profile) { build_stubbed(:profile, user: other_user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, user: user, product: product, role: "owner") }
    let(:user_without_profile) { build_stubbed(:user) }

    permissions :index? do

      it "allows access for anybody" do
        expect(subject).to permit(user)
        expect(subject).to permit(other_user)
        expect(subject).to permit(user_without_profile)
      end
    end

    permissions :new?, :create? do

      it "only allows access for users with profile" do
        expect(subject).to permit(user)
        expect(subject).to permit(other_user)
        expect(subject).to_not permit(user_without_profile)
      end
    end

    permissions :show? do

      it "allows access for users with profile" do
        expect(subject).to permit(user, product)
        expect(subject).to permit(other_user, product)
        expect(subject).to_not permit(user_without_profile, product)
      end
    end

    permissions :edit?, :update?, :destroy? do

      it "only allows access for product user" do
        expect(subject).to permit(user, product)
        expect(subject).to_not permit(other_user, product)
      end
    end

    permissions :index_product_owner_panels? do

      it "only allows access for owner" do
        expect(subject).to permit(user, product)
        expect(subject).to_not permit(other_user, product)
      end
    end
  end

  describe "policies belongs to product owner" do
    let(:owner) { create(:user) }
    let(:member) { build_stubbed(:user) }
    let!(:owner_profile) { build_stubbed(:profile, user: owner) }
    let!(:member_profile) { build_stubbed(:profile, user: member) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:owner_product_user) { create(:product_user, user_id: owner.id, product: product, role: "owner") }
    let(:member_product_user) { build_stubbed(:product_user, user_id: member.id, product: product, role: "member") }

    permissions :destroy_product_users?, :destroy_product_customer_users? do
      it "allows access only for owner" do
        expect(subject).to permit(owner, product)
        expect(subject).to_not permit(member, product)
      end
    end
  end

  describe "policies belongs to group invitation" do
    let(:owner) { create(:user) }
    let(:member) { build_stubbed(:user) }
    let!(:owner_profile) { build_stubbed(:profile, user: owner) }
    let!(:member_profile) { build_stubbed(:profile, user: member) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:owner_product_user) { create(:product_user, user_id: owner.id, product: product, role: "owner") }
    let(:member_product_user) { build_stubbed(:product_user, user_id: member.id, product: product, role: "member") }

    permissions :new_group_invitations? do
      it "only allows access for owner" do
        expect(subject).to permit(owner, product)
        expect(subject).to_not permit(member, product)
      end
    end

    permissions :create_group_invitations? do
      it "only allows access for owner" do
        expect(subject).to permit(owner, product)
        expect(subject).to_not permit(member, product)
      end
    end
  end
end