require "rails_helper"

RSpec.describe ProductUsecase, type: :model do

  it "has a valid factory" do
    expect(build(:product_usecase)).to be_valid
  end
  
  it "is invalid without example" do
    expect(build(:product_usecase, example: nil)).not_to be_valid
  end

  it "is invalid without detail" do
    expect(build(:product_usecase, detail: nil)).not_to be_valid
  end

  it { is_expected.to validate_presence_of(:example).with_message(/can't be blank/) }
  it { is_expected.to validate_presence_of(:detail).with_message(/can't be blank/) }
  it { is_expected.to validate_length_of(:example).is_at_most(80).with_message(/can't be longer than 80 characters/) }
  it { is_expected.to validate_presence_of(:product) }
  
  it { is_expected.to belong_to(:product) }
end