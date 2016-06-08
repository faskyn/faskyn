require "rails_helper"

RSpec.describe ProductLead, type: :model do

  describe "model validations" do
    let(:product) { create(:product, :product_with_nested_attrs) }

    it "has a valid factory" do
      expect(build_stubbed(:product_lead, product: product)).to be_valid
    end
    
    it "is invalid without example" do
      expect(build_stubbed(:product_lead, lead: nil)).not_to be_valid
    end

    it "is invalid without detail" do
      expect(build_stubbed(:product_lead, pitch: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:lead).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:pitch).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:lead).is_at_most(80).with_message(/can't be longer than 80 characters/) }
    it { is_expected.to validate_presence_of(:product) }
    
    it { is_expected.to belong_to(:product).touch }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, user: user, product: product, role: "owner") }
    let!(:product_lead) { create(:product_lead, product: product) }

    it "returns product user" do
      expect(product_lead.owner).to eq(user)
    end
  end

  # describe "custom validations" do
    
  #   context "format lead website" do

  #     it "returns nil if empty string" do
  #       website = ""
  #       expect(website.format_lead_website).to eq(nil)
  #     end

  #     it "returns http://webiste if http already present" do
  #       website = "https://haha.com"
  #       expect(website.format_lead_website).to eq("http://haha.com")
  #     end
  #   end
  # end
end