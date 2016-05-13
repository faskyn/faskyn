# require "rails_helper"

# RSpec.describe ProductFeature, type: :model do
#   let(:product) { create(:product, :product_with_nested_attrs) }

#   it "has a valid factory" do
#     expect(build_stubbed(:product_feature, product: product)).to be_valid
#   end
  
#   it "is invalid without example" do
#     expect(build_stubbed(:product_feature, feature: nil)).not_to be_valid
#   end

#   it { is_expected.to validate_presence_of(:feature).with_message(/can't be blank/) }
#   it { is_expected.to validate_presence_of(:product) }
  
#   it { is_expected.to belong_to(:product).touch }

# end