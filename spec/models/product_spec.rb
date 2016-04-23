require "rails_helper"

RSpec.describe Product, type: :model do

  describe "nested attribute validation" do

    #let(:product) { create(:product) }
    #let(:product_feature) { FactoryGirl.create(:product_feature, product: product ) }
    #let(:product_competition) { FactoryGirl.create(:product_competition, product: product) }

    #let(:product_with_attrs) { create(:product) do |product| 
                               #   product.product_features.create(attributes_for(:product_feature))
                               #   product.product_competitions.create(attributes_for(:product_competition))
                               #   product.product_usecases.create(attributes_for(:product_usecase))
                               # end }

    #let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let(:product_without_nested_attrs) { create(:product) }
    #let(:new_product) { create(:product, :with_children) }
    #let(:new_product_2) { create(:product, :with_product_all) }
    #let(:test_product2) {create(:product) { |product| product.product_features.create(attributes_for(:product))}}
    #let!(:industry) { create(:industry, name: "AI") }
    #let(:product_feature) { create(:product_feature)}

    # it "has a valid factory" do
    # #   expect(create(:product, :product_with_nested_attrs)).to be_valid
    #   attrs = attributes_for(:product).merge({
    #     user_id: user.id,
    #     product_features_attributes: attributes_for(:product_feature),
    #     product_usecases_attributes: attributes_for(:product_usecase),
    #     product_competitions_attributes: attributes_for(:product_competition),
    #     product_industry: attributes_for(:industry)
    #   })
    #     #attrs = attributes_for(:product, product_features: build(:product_feature)
    #   expect(Product.new(attrs)).to be_valid
    # end

    # it "has a valid factory 2" do
    #   product = build(:product).merge({
    #     user_id: user.id,
    #     product_features: attributes_for(:product_feature, product: product),
    #     product_competitions: attributes_for(:product_competition, product: product),
    #     product_usecases: attributes_for(:product_usecase, product: product)
    #     })
    #   expect(product).to be_valid
    # end

    # it "has a valid factory 2" do
    #   expect(create(:product) { |product| product.product_features.create(attributes_for(:product))}).to be_valid
    # end

    it "has a valid factory 3" do
      expect(product).to be_valid
    end

    # it "has a valid factory 4" do
    #   expect(product_with_attrs).to be_valid
    # end

    # it "has a valid factory 5" do
    #   expect(new_product).to be_valid
    # end

    # it "has a valid factory 6" do
    #   expect(new_product_2).to be_valid
    # end

    # it "has a valid factory 7" do
    #   p = build(:product, :with_children)
    #   puts "haha"
    #   puts p.product_competitions
    #   expect(p).to be_valid
    # end

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
  end
end