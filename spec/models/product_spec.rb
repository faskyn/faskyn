require "rails_helper"

RSpec.describe Product, type: :model do

  describe "nested attribute validation" do
    let!(:user) { create(:user) }
    let!(:industry) { create(:industry) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let(:product_without_nested_attrs) { build(:product) }

    it "has a valid factory" do
      expect(product).to be_valid
    end

    it "has one more valid factory" do
      attrs = attributes_for(:product, user_id: user.id, industry_ids: [ industry.id ]).merge(
        product_customers_attributes: [attributes_for(:product_customer)],
        # product_competitions_attributes: [attributes_for(:product_competition)],
        product_usecases_attributes: [attributes_for(:product_usecase)]
        )
      expect(Product.new(attrs)).to be_valid
      expect(product).to be_valid
    end

    it "is not a valid factroy without nested attrs" do
      expect(product_without_nested_attrs).not_to be_valid
    end
  end

  describe "model validations" do

    it "is invalid without name" do
      expect(build_stubbed(:product, name: nil)).not_to be_valid
    end

    it "is invalid without website" do
      expect(build_stubbed(:product, website: nil)).not_to be_valid
    end

    it "is invalid without description" do
      expect(build_stubbed(:product, description: nil)).not_to be_valid
    end

    it "is invalid without oneliner" do
      expect(build_stubbed(:product, oneliner: nil)).not_to be_valid
    end
  
    it { is_expected.to callback(:format_website).before(:validation) }

    it { is_expected.to validate_presence_of(:name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:website).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:oneliner).with_message(/can't be blank/) }

    it { is_expected.to validate_length_of(:name).is_at_most(140).with_message(/can't be longer than 140 characters/) }
    it { is_expected.to validate_length_of(:oneliner).is_at_most(140).with_message(/can't be longer than 140 characters/) }
    it { is_expected.to validate_length_of(:description).is_at_most(500).with_message(/can't be longer than 500 characters/) }

    it { is_expected.to accept_nested_attributes_for(:product_usecases) }

    it { is_expected.to have_many(:product_usecases).dependent(:destroy) }
    it { is_expected.to have_many(:product_customers).dependent(:destroy) }
    it { is_expected.to have_many(:product_leads).dependent(:destroy) }

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