require 'rails_helper'

describe ReviewPolicy do
  subject { ReviewPolicy }

  describe "policies belongs to product" do
    let(:referencer) { build_stubbed(:user) }
    let(:other_user) { build_stubbed(:user) }
    let(:review) { build_stubbed(:review, user: referencer) }

    permissions :edit?, :update? do

      it "only allows access for product user" do
        expect(subject).to permit(referencer, review)
        expect(subject).to_not permit(other_user, review)
      end
    end
  end
end