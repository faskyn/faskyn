require "rails_helper"

RSpec.describe Profile, type: :model do

  describe "model validations" do

    it "has a valid factory" do
      expect(build(:social)).to be_valid
    end

    it "is invalid without provider" do
      expect(build(:social, provider: nil)).not_to be_valid
    end

    it "is invalid without uid" do
      expect(build(:social, uid: nil)).not_to be_valid
    end

    it "is invalid without token" do
      expect(build(:social, token: nil)).not_to be_valid
    end
  end
end
