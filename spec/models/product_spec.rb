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

    # it "has one more valid factory" do
    #   attrs = attributes_for(:product, industry_ids: [ industry.id ], user_ids: [ user.id]).merge(
    #     product_customers_attributes: [attributes_for(:product_customer)]
    #     )
    #   expect(Product.new(attrs)).to be_valid
    # end

    it "is not a valid factroy without nested attrs" do
      expect(product_without_nested_attrs).not_to be_valid
    end

    it "validates the number of industries" do
      attrs = attributes_for(:product, industry_ids: [ industry.id ])
      product = Product.new(attrs)
      product.valid? 
      expect(product.errors[:base]).to include("You have to add at least 1 current or potential customer.")
    end

    it "validates the number of product industries" do
      attrs = attributes_for(:product, industry_ids: []).merge(
        product_customers_attributes: [attributes_for(:product_customer)],
        product_leads_attributes: [attributes_for(:product_lead)]
        )
      product = Product.new(attrs)
      product.valid? 
      expect(product.errors[:base]).to include("You have to choose at least 1 industry.")
    end

    it "validates the number of product users" do
      attrs = attributes_for(:product, industry_ids: [ industry.id ]).merge(
        product_customers_attributes: [attributes_for(:product_customer)],
        product_leads_attributes: [attributes_for(:product_lead)]
        )
      product = Product.new(attrs)
      product.valid? 
      expect(product.errors[:base]).to include("There is no user associated!")
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

    it { is_expected.to have_many(:product_customers).dependent(:destroy) }
    it { is_expected.to have_many(:product_leads).dependent(:destroy) }
    it { is_expected.to have_many(:industry_products).dependent(:destroy) }
    it { is_expected.to have_many(:industries).through(:industry_products) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:commenters).through(:comments) }
    it { is_expected.to have_many(:users).through(:product_users) }
    it { is_expected.to have_many(:product_users).dependent(:destroy) }
  
    it { is_expected.to callback(:format_website).before(:validation) }

    it { is_expected.to validate_presence_of(:name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:website).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:oneliner).with_message(/can't be blank/) }

    it { is_expected.to validate_length_of(:name).is_at_most(140).with_message(/can't be longer than 140 characters/) }
    it { is_expected.to validate_length_of(:oneliner).is_at_most(140).with_message(/can't be longer than 140 characters/) }
    it { is_expected.to validate_length_of(:description).is_at_most(500).with_message(/can't be longer than 500 characters/) }

    it { is_expected.to accept_nested_attributes_for(:industry_products) }
    it { is_expected.to accept_nested_attributes_for(:product_customers) }
    it { is_expected.to accept_nested_attributes_for(:product_leads) }
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, user_id: user.id, product_id: product.id, role: "owner") }
    let(:industry) { create(:industry, name: "Automotive") }
    before do
      product.industries << industry
    end

    it "sets owner" do
      expect(product.owner).to eq(user)
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