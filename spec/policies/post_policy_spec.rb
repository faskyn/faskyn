require 'rails_helper'

describe PostPolicy do
  subject { PostPolicy }

  let(:post_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let!(:profile) { build_stubbed(:profile, user: post_user) }
  let!(:other_profile) { build_stubbed(:profile, user: other_user) }
  let(:post) { build_stubbed(:post, user: post_user) }
  let(:user_without_profile) { build_stubbed(:user) }

  permissions :index? do

    it "allows acces for anybody" do
      expect(subject).to permit(post_user, post)
      expect(subject).to permit(other_user)
      expect(subject).to permit(user_without_profile)
    end
  end

  permissions :new?, :create? do

    it "only allows acces for users with profile" do
      expect(subject).to permit(post_user)
      expect(subject).to permit(other_user)
      expect(subject).to_not permit(user_without_profile)
    end
  end

  permissions :show? do

    it "allows access for users with profile" do
      expect(subject).to permit(post_user, post)
      expect(subject).to permit(other_user, post)
      expect(subject).to_not permit(user_without_profile, post)
    end
  end

  permissions :edit?, :update?, :destroy? do

    it "only allows acces for post user" do
      expect(subject).to permit(post_user, post)
      expect(subject).to_not permit(other_user, post)
    end
  end
end