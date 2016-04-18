require "rails_helper"

RSpec.describe Profile, type: :model do

  describe "model validations" do
    subject { build(:profile) }

    it "has a valid factory" do
      expect(build(:profile)).to be_valid
    end  

    it "is invalid without lastname" do
      expect(build(:profile, last_name: nil)).not_to be_valid
    end

    it "is invalid without title" do
      expect(build(:profile, job_title: nil)).not_to be_valid
    end

    it "is invalid without company" do
      expect(build(:profile, company: nil)).not_to be_valid
    end

    it "is invalid without user_id" do
      expect(build(:profile, user_id: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:first_name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:last_name).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:job_title).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:company).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:job_title).is_at_most(50) }
    it { is_expected.to validate_length_of(:company).is_at_most(50) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:socials) }
  end

  describe "instance methods" do
    let(:profile) { build(:profile) }

    it "returns full name as a string" do
      expect(profile.full_name).to eq("John Doe")
    end
  end

  describe "carrierwave uploader"
  # do
  #   include Carriereave::Test::Matchers
  #   let(:profile) { create(:profile) }
  #   let(:uploader) { AvatarUploader.new(profile, :avatar) }

  #   before do
  #     AvatarUploader.enable_processing = true

  #     File.open(/assets/)
  #   end


  # end
end