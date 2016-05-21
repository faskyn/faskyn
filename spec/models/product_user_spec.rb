require "rails_helper"

RSpec.describe ProductUser, type: :model do

  describe "model validations" do
    let(:product) { create(:product, :product_with_nested_attrs) }

    it "has a valid factory" do
      expect(build_stubbed(:product_user, product: product)).to be_valid
    end
    
    it "is invalid without role" do
      expect(build_stubbed(:product_user, role: nil)).not_to be_valid
    end

    it "is invalid without user" do
      expect(build_stubbed(:product_user, user: nil)).not_to be_valid
    end

    it "is invalid without product" do
      expect(build_stubbed(:product_user, product: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:product) }
    it { is_expected.to validate_presence_of(:role) }
    
    it { is_expected.to belong_to(:product).touch }
    it { is_expected.to belong_to(:user) }
  end
end