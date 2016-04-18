require "rails_helper"

RSpec.describe IndustryProduct, type: :model do

  describe "model validation" do

    it "has a valid factory" do
      expect(build(:industry_product)).to be_valid
    end

    it "is not valid without product" do
      expect(build(:industry_product, product_id: nil)).not_to be_valid
    end

    it "is not valid without industry" do
      expect(build(:industry_product, industry: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:industry) }
    it { is_expected.to validate_presence_of(:product) }

    it { is_expected.to belong_to(:industry) }
    it { is_expected.to belong_to(:product) }
  end
end