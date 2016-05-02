require 'rails_helper'

describe ProfilePolicy do
  subject { ProfilePolicy }

  let(:current_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) } 
  let(:profile) { build_stubbed(:profile, user: current_user) }
  let(:other_profile) { build_stubbed(:profile, user: other_user) }

  permissions :show? do

    it "allows acces for anybody" do
      expect(subject).to permit(current_user, other_profile)
      expect(subject).to permit(current_user, profile)
    end
  end

  permissions :create?, :new? do

    it "allows acces for anybody" do
      expect(subject).to permit(current_user)
      expect(subject).to permit(other_user)
    end
  end

  permissions :edit?, :update?, :add_socials? do

    it "allows update for current user" do
      expect(subject).to permit(current_user, profile)
    end

    it "prevents update if other user" do
      expect(subject).not_to permit(current_user, other_profile)
    end
  end
end