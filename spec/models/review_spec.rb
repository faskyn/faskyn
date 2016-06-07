require "rails_helper"

RSpec.describe Review, type: :model do

  describe "model validations" do
    it "is has a valid factory" do
      expect(build_stubbed(:review)).to be_valid
    end

    it "is invalid without user" do
      expect(build_stubbed(:review, user: nil)).not_to be_valid
    end

    it "is invalid without product customer" do
      expect(build_stubbed(:review, product_customer: nil)).not_to be_valid
    end

    it "is invalid without body" do
      expect(build_stubbed(:review, body: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:body).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:user).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:product_customer).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:body).is_at_most(1000).with_message(/can't be longer than 1000 characters/) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:product_customer).touch }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end
end