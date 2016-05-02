require 'rails_helper'

describe ProductPolicy do
  subject { ProductPolicy }

  let(:product_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let!(:profile) { build_stubbed(:profile, user: product_user) }
  let!(:other_profile) { build_stubbed(:profile, user: other_user) }
  let(:product) { build_stubbed(:product, user: product_user) }
  let(:user_without_profile) { build_stubbed(:user) }

  permissions :index? do

    it "allows acces for anybody" do
      expect(subject).to permit(product_user)
      expect(subject).to permit(other_user)
      expect(subject).to permit(user_without_profile)
    end
  end

  permissions :new?, :create? do

    it "only allows acces for users with profile" do
      expect(subject).to permit(product_user)
      expect(subject).to permit(other_user)
      expect(subject).to_not permit(user_without_profile)
    end
  end

  permissions :show? do

    it "allows access for users with profile" do
      expect(subject).to permit(product_user, product)
      expect(subject).to permit(other_user, product)
      expect(subject).to_not permit(user_without_profile, product)
    end
  end

  permissions :edit?, :update?, :destroy? do

    it "only allows acces for product user" do
      expect(subject).to permit(product_user, product)
      expect(subject).to_not permit(other_user, product)
    end
  end
end