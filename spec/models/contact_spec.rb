require "rails_helper"

RSpec.describe Contact, type: :model do

  describe "model validation" do

    it "has a valid factory" do
      expect(build_stubbed(:contact)).to be_valid
    end

    it "is invalid without name" do
      expect(build_stubbed(:contact, name: nil)).not_to be_valid
    end

    it "is invalid without email" do
      expect(build_stubbed(:contact, email: nil)).not_to be_valid
    end

    it "is invalid without comment" do
      expect(build_stubbed(:contact, comment: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:name).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:name).is_at_most(50).with_message(/can't be longer than 50 characters/) }
    it { is_expected.to validate_presence_of(:email).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:email).is_at_most(255).with_message(/can't be longer than 255 characters/) }
    it { is_expected.to allow_value("info@gmail.com").for(:email) }
    it { is_expected.to validate_presence_of(:comment).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:comment).is_at_most(500).with_message(/can't be longer than 500 characters/) }
  end
end