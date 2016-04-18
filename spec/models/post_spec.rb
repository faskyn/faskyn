require "rails_helper"

RSpec.describe Post, type: :model do

  describe "model validations" do

    it "is has a valid factory" do
      expect(build(:post)).to be_valid
    end

    it "is valid without product image" do
      expect(build(:post, post_image: nil)).to be_valid
    end

    it "is invalid without body" do
      expect(build(:post, body: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:body).with_message(/can't be blank/) }
    it { is_expected.to validate_presence_of(:user).with_message(/can't be blank/) }
    it { is_expected.to validate_length_of(:body).is_at_most(500).with_message(/can't be longer than 500 characters/) }
 
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:post_comments) }
    it { is_expected.to have_many(:users).through(:post_comments) }
  end

  describe "instance methods" do
    let(:post_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:comment_user_2) { create(:user) }
    let(:post) { create(:post, user: post_user) }
    let(:post_comment) { create(:post_comment, post: post, user: comment_user) }
    let!(:post_comment_2) { create(:post_comment, post: post, user: comment_user_2) }

    it "send_post_comment_creation_notification" do
      expect{
        post.send_post_comment_creation_notification(post_comment)
      }.to change{Notification.count}.by(2)
    end
  end
end