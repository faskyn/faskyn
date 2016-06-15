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

    it "is invalid if the user posted in the last 24 hrs" do
      user = create(:user)
      first_post = create(:post, user: user, created_at: Time.zone.now - 12.hours)
      expect(build(:post, user: user, body: "haha")).not_to be_valid
    end

    #shoulda matcher validations are taken out because they need user defined for the custom validator
    #it doesn't cause any problem since validations are tested above; they were here to decrease cognitive load

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:commenters).through(:comments) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:post) { create(:post, created_at: Time.zone.now - 12.hours) }
    let!(:old_post) { create(:post, created_at: Time.zone.now - 36.hours) }

    it "last_day" do
      expect(Post.last_day).to eq([post])
      expect(Post.last_day).not_to include(old_post)
    end
  end
end