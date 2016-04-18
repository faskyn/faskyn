require "rails_helper"

RSpec.describe Industry, type: :model do

  describe "model validation" do

    it "has a valid factory" do
      expect(build(:industry)).to be_valid
    end

    it "is invalid without name" do
      expect(build(:industry, name: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to have_many(:industry_products).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:industry_products) }

    it { is_expected.to accept_nested_attributes_for(:industry_products) }
  end
end