require "rails_helper"

RSpec.describe ProductFeature, type: :model do

  it "has a valid factory" do
    expect(build(:product_feature)).to be_valid
  end
  
  it "is invalid without example" do
    expect(build(:product_feature, feature: nil)).not_to be_valid
  end

  it { is_expected.to validate_presence_of(:feature).with_message(/can't be blank/) }
  it { is_expected.to validate_presence_of(:product) }
  
  it { is_expected.to belong_to(:product) }

end