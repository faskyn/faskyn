require "rails_helper"
# require "refile/file_double"

RSpec.describe Company, type: :model do

  describe "model validations" do
    let!(:product) { create(:product, :product_with_nested_attrs) }

    it "has a valid factory" do
      expect(build_stubbed(:company, product: product)).to be_valid
    end  

    it "is invalid without name" do
      expect(build_stubbed(:company, product: product, name: nil)).not_to be_valid
    end

    it "is invalid without location" do
      expect(build_stubbed(:company, product: product, location: nil)).not_to be_valid
    end

    it "is invalid without founded date" do
      expect(build_stubbed(:company, product: product, founded: nil)).not_to be_valid
    end

    it "is invalid without team size" do
      expect(build_stubbed(:company, product: product, team_size: nil)).not_to be_valid
    end

    it "is invalid without engineer number" do
      expect(build_stubbed(:company, product: product, engineer_number: nil)).not_to be_valid
    end

    it "is invalid without revenue type" do
      expect(build_stubbed(:company, product: product, revenue_type: nil)).not_to be_valid
    end

    it "is invalid without revenue" do
      expect(build_stubbed(:company, product: product, revenue: nil)).not_to be_valid
    end

    # it "allows attaching a file" do
    #   company = build_stubbed(:company, product: product)

    #   company.company_pitch_attachment = Refile::FileDouble.new("dummy", "logo.pdf", content_type: "application/pdf")
    #   company.save

    #   expect(company.company_pitch_attachment_id).not_to be_nil
    # end

    it { is_expected.to callback(:format_investment).before(:validation) }

    it { is_expected.to validate_presence_of(:name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:location).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:founded).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:team_size).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:engineer_number).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:revenue_type).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:revenue).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:website).with_message(/can't be blank/) }

    it { is_expected.to validate_numericality_of(:team_size).with_message(/must be an integer/) }
    it { is_expected.to validate_numericality_of(:engineer_number).with_message(/must be an integer/) }
    it { is_expected.to validate_numericality_of(:investment).with_message(/must be an integer/) }

    it { is_expected.to belong_to(:product) }
  end
end