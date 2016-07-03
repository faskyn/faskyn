require 'rails_helper'

describe CompanyPolicy do
  subject { CompanyPolicy }

  describe "policies belong to company" do
    let(:user) { build_stubbed(:user) }
    let(:other_user) { build_stubbed(:user) }
    let!(:profile) { build_stubbed(:profile, user: user) }
    let!(:other_profile) { build_stubbed(:profile, user: other_user) }
    let(:product) { build_stubbed(:product, :product_with_nested_attrs, owner: user) }
    let(:user_without_profile) { build_stubbed(:user) }
    let!(:company) { build_stubbed(:company, product: product) }

    permissions :show? do

      it "only allows acces for people with profile" do
        expect(subject).to permit(user)
        expect(subject).to permit(other_user)
        expect(subject).to_not permit(user_without_profile)
      end
    end

    permissions :edit?, :update? do

      it "only allow acces for product owner" do
        expect(subject).to permit(user, company)
        expect(subject).to_not permit(other_user, company)
        expect(subject).to_not permit(user_without_profile, company)
      end
    end
  end
end