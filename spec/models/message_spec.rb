require "rails_helper"

RSpec.describe Message, type: :model do

  describe "model validation" do

    it "has a valid factory" do
      expect(build_stubbed(:message)).to be_valid
    end

    it "has a valid factory for body" do
      expect(build_stubbed(:message_with_body)).to be_valid
    end

    it "has a valid factory for attachment" do
      expect(build_stubbed(:message_with_attachment)).to be_valid
    end

    it "is not valid without user" do
      expect(build_stubbed(:message, user: nil)).not_to be_valid
    end

    it "is not valid without conversation" do
      expect(build_stubbed(:message, conversation: nil )).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:conversation) }
    it { is_expected.to validate_length_of(:body).is_at_most(5000).with_message(/can't be longer than 5000 characters/) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:conversation) }
  end

  describe "scopes" do
    let(:message_with_file) { create(:message_with_attachment) }
    let(:message_with_body) { create(:message_with_body) }
    let(:message_with_link) { create(:message_with_body, link: message_with_body.body) }

    it "message with file" do
      expect(Message.with_file).to eq([message_with_file])
      expect(Message.with_file).not_to include(message_with_body)
    end

    it "message with link" do
      expect(Message.with_link).to eq([message_with_link])
      expect(Message.with_link).not_to include(message_with_file)
    end
  end

  describe "instance methods" do
  end

  describe "class methods" do
  end
end