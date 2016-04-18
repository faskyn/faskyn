require "rails_helper"

RSpec.describe PostCommentReply, type: :model do

  describe "model validations" do

    it "is has a valid factory" do
      expect(build(:post_comment_reply)).to be_valid
    end

    it "is invalid without body" do
      expect(build(:post_comment_reply, body: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build(:post_comment_reply, post_comment: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build(:post_comment_reply, user: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:post_comment) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(500) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post_comment).touch }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:post_comment_reply) { create(:post_comment_reply, user: user, updated_at: DateTime.now - 3 ) }
    let(:new_post_comment_reply) { create(:post_comment_reply, user: user, updated_at: DateTime.now - 2 ) }

    it "ordered" do
      expect(PostCommentReply.ordered).to eq([post_comment_reply, new_post_comment_reply])
    end
  end
end