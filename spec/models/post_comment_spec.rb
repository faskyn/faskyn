require "rails_helper"

RSpec.describe PostComment, type: :model do

  describe "model validations" do
    
    it "is has a valid factory" do
      expect(build_stubbed(:post_comment)).to be_valid
    end

    it "is invalid without body" do
      expect(build_stubbed(:post_comment, body: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:post_comment, post: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:post_comment, user: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:post) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(500) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post).touch }
    it { is_expected.to have_many(:post_comment_replies) }
    it { is_expected.to have_many(:users).through(:post_comment_replies) } 
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:post_comment) { create(:post_comment, user: user, updated_at: DateTime.now - 3 ) }
    let(:new_post_comment) { create(:post_comment, user: user, updated_at: DateTime.now - 2 ) }

    it "ordered" do
      expect(PostComment.ordered).to eq([new_post_comment, post_comment])
    end
  end

  describe "instance methods" do
    let(:post_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:reply_user) { create(:user) }
    let(:reply_user_2) { create(:user) }
    let(:post) { create(:post, user: post_user) }
    let(:post_comment) { create(:post_comment, user: comment_user) }
    let(:post_comment_reply) { create(:post_comment_reply, post_comment: post_comment, user: reply_user) }
    let!(:post_comment_reply_2) { create(:post_comment_reply, post_comment: post_comment, user: reply_user_2) }
    
    it "send_post_comment_reply_creation_notification" do
      expect{
        post_comment.send_post_comment_reply_creation_notification(post_comment_reply)
        }.to change{Notification.count}.by(3)
    end
  end
end