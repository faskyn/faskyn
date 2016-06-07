require "rails_helper"

RSpec.describe CommentReply, type: :model do

  describe "model validations" do

    it "is has a valid factory" do
      expect(build_stubbed(:comment_reply)).to be_valid
    end

    it "is invalid without body" do
      expect(build_stubbed(:comment_reply, body: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:comment_reply, comment: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:comment_reply, user: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(500) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:comment).touch }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:commentable) { create(:post) }
    let(:comment) { create(:comment, commentable: commentable) }
    let(:comment_reply) { create(:comment_reply, comment: comment, user: user, updated_at: DateTime.now - 3 ) }
    let(:new_comment_reply) { create(:comment_reply, comment: comment, user: user, updated_at: DateTime.now - 2 ) }

    it "ordered" do
      expect(CommentReply.ordered).to eq([comment_reply, new_comment_reply])
    end
  end

  describe "instance methods" do
    let(:commentable_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:reply_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:commentable) { create(:post, user: commentable_user) }
    let(:comment) { create(:comment, commentable: commentable, user: comment_user) }
    let(:comment_reply) { create(:comment_reply, comment: comment, user: reply_user)}
    let!(:other_reply) { create(:comment_reply, comment: comment, user: other_user) }
    
    it "send_comment_creation_notification" do
      expect{
        comment_reply.send_comment_reply_creation_notification(comment)
        }.to change{Notification.count}.by(3)
    end
  end
end