require "rails_helper"

RSpec.describe Post, type: :model do

  describe "model validations" do

    it "is has a valid factory" do
      expect(build_stubbed(:post)).to be_valid
    end

    it "is valid without product image" do
      expect(build_stubbed(:post, post_image: nil)).to be_valid
    end

    it "is invalid without body" do
      expect(build_stubbed(:post, body: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:body).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:user).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:body).is_at_most(500).with_message(/can't be longer than 500 characters/) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:commenters).through(:comments) }
  end
end