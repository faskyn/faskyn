require "rails_helper"

RSpec.describe Product, type: :model do

  describe "nested attribute validation" do
    let(:product) { create(:product, :product_with_nested_attrs) }
    let(:product_without_nested_attrs) { create(:product) }

    it "has a valid factory 3" do
      expect(product).to be_valid
    end

    it "is not a valid factroy without nested attrs" do
      expect(build(:product)).not_to be_valid
    end
  end

  describe "model validations" do

    it "is invalid without name" do
      expect(build(:product, name: nil)).not_to be_valid
    end

    it "is invalid without company" do
      expect(build(:product, company: nil)).not_to be_valid
    end

    it "is invalid without website" do
      expect(build(:product, website: nil)).not_to be_valid
    end

    it "is invalid without description" do
      expect(build(:product, description: nil)).not_to be_valid
    end

    it "is invalid without oneliner" do
      expect(build(:product, oneliner: nil)).not_to be_valid
    end
  
    it { is_expected.to callback(:format_website).before(:validation) }
    it { is_expected.to validate_presence_of(:name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:company).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:website).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:description).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:oneliner).with_message(/can't be blank/) }

    # it "validates there is at least one competition/usecase/feature/industry" do
    #   expect{ build(:product) }.to raise_error { |error|
    #     expect(error).to be_a(StandardError)
    #   }
    # end

    it { is_expected.to accept_nested_attributes_for(:product_competitions) }
    it { is_expected.to accept_nested_attributes_for(:product_features) }
    it { is_expected.to accept_nested_attributes_for(:product_usecases) }

    it { is_expected.to have_many(:product_competitions).dependent(:destroy) }
    it { is_expected.to have_many(:product_features).dependent(:destroy) }
    it { is_expected.to have_many(:product_usecases).dependent(:destroy) }

    it { is_expected.to have_many(:industry_products).dependent(:destroy) }
    it { is_expected.to have_many(:industries).through(:industry_products) }

    it { is_expected.to belong_to(:user) }
  end

  describe "instance methods" do
    let(:product) { create(:product, :product_with_nested_attrs) }
    let(:industry) { create(:industry, name: "Automotive") }
    before do
      product.industries << industry
    end

    it "industries all" do
      expect(product.industries_all).to eq("AI, Automotive")
    end

    context "formats website" do

      it "is valid when addreess without http" do
        product.website = "faskyn.com"
        expect(product).to be_valid
      end

      it "is invalid when wrong format" do
        product.website = "faskyn"
        expect(product).not_to be_valid
      end
    end
  end
end