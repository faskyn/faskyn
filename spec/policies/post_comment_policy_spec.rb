require 'rails_helper'

describe PostCommentPolicy do
  subject { PostCommentPolicy }

  let(:post_comment_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let!(:profile) { build_stubbed(:profile, user: post_comment_user) }
  let!(:other_profile) { build_stubbed(:profile, user: other_user) }
  let(:post_comment) { build_stubbed(:post_comment, user: post_comment_user) }
  let(:user_without_profile) { build_stubbed(:user) }

  permissions :create? do

    it "only allows acces for users with profile" do
      expect(subject).to permit(post_comment_user)
      expect(subject).to permit(other_user)
      expect(subject).to_not permit(user_without_profile)
    end
  end

  permissions :update?, :destroy? do

    it "only allows acces for post user" do
      expect(subject).to permit(post_comment_user, post_comment)
      expect(subject).to_not permit(other_user, post_comment)
    end
  end
end