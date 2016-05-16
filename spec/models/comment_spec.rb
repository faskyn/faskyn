require "rails_helper"

RSpec.describe Comment, type: :model do

  describe "model validations" do
    let(:commentable) { create(:post) }
    
    it "is has a valid factory" do
      expect(build_stubbed(:comment, commentable: commentable)).to be_valid
    end

    it "is invalid without body" do
      expect(build_stubbed(:comment, body: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:comment, commentable: nil)).not_to be_valid
    end

    it "is invalid without post" do
      expect(build_stubbed(:comment, user: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:commentable) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(500) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commentable).touch }
    it { is_expected.to have_many(:comment_replies) }
    it { is_expected.to have_many(:users).through(:comment_replies) } 
  end

  describe "scopes" do
    let(:commentable) { create(:post) }
    let(:user) { create(:user) }
    let(:comment) { create(:comment, user: user, commentable: commentable, updated_at: DateTime.now - 3 ) }
    let(:new_comment) { create(:comment, user: user, commentable: commentable, updated_at: DateTime.now - 2 ) }

    it "ordered" do
      expect(Comment.ordered).to eq([new_comment, comment])
    end
  end

  describe "instance methods" do
    let(:commentable_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:commentable) { create(:post, user: commentable_user) }
    let(:comment) { create(:comment, commentable: commentable, user: comment_user) }
    let!(:other_comment) { create(:comment, commentable: commentable, user: other_user) }
    
    it "send__comment_creation_notification" do
      expect{
        comment.send_comment_creation_notification(commentable)
        }.to change{Notification.count}.by(2)
    end
  end
end