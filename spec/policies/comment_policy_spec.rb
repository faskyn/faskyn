require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy }

  let(:comment_user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let!(:profile) { build_stubbed(:profile, user: comment_user) }
  let!(:other_profile) { build_stubbed(:profile, user: other_user) }
  let(:commentable) { build_stubbed(:post) }
  let(:comment) { build_stubbed(:comment, commentable: commentable, user: comment_user) }
  let(:user_without_profile) { build_stubbed(:user) }

  permissions :create? do

    it "only allows acces for users with profile" do
      expect(subject).to permit(comment_user)
      expect(subject).to permit(other_user)
      expect(subject).to_not permit(user_without_profile)
    end
  end

  permissions :update?, :destroy? do

    it "only allows acces for comment user" do
      expect(subject).to permit(comment_user, comment)
      expect(subject).to_not permit(other_user, comment)
    end
  end
end