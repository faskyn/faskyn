require 'rails_helper'

describe ProductLeadPolicy do
  subject { ProductLeadPolicy }

  let(:product_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let!(:profile) { build_stubbed(:profile, user: product_user) }
  let!(:other_profile) { build_stubbed(:profile, user: other_user) }
  let(:product) { build_stubbed(:product, user: product_user) }
  let(:user_without_profile) { build_stubbed(:user) }

  permissions :show? do

    it "only allows acces for people with profile" do
      expect(subject).to permit(product_user)
      expect(subject).to permit(other_user)
      expect(subject).to_not permit(user_without_profile)
    end
  end
end