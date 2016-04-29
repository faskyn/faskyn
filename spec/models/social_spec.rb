require "rails_helper"

RSpec.describe Profile, type: :model do

  describe "model validations" do

    it "has a valid factory" do
      expect(build_stubbed(:social)).to be_valid
    end

    it "is invalid without provider" do
      expect(build_stubbed(:social, provider: nil)).not_to be_valid
    end

    it "is invalid without uid" do
      expect(build_stubbed(:social, uid: nil)).not_to be_valid
    end

    it "is invalid without token" do
      expect(build_stubbed(:social, token: nil)).not_to be_valid
    end
  end
end
