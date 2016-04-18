require "rails_helper"

RSpec.describe ProductCompetition, type: :model do

  it "has a valid factory" do
    expect(build(:product_competition)).to be_valid
  end
  
  it "is invalid without competitor" do
    expect(build(:product_competition, competitor: nil)).not_to be_valid
  end

  it "is invalid without differentiator" do
    expect(build(:product_competition, differentiator: nil)).not_to be_valid
  end

  it { is_expected.to validate_presence_of(:competitor).with_message(/can't be blank/) }
  it { is_expected.to validate_presence_of(:differentiator).with_message(/can't be blank/) }
  it { is_expected.to validate_length_of(:competitor).is_at_most(80).with_message(/can't be longer than 80 characters/) }
  it { is_expected.to validate_presence_of(:product) }
  
  it { is_expected.to belong_to(:product) }

end