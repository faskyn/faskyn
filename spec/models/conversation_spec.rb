require "rails_helper"

RSpec.describe Conversation, type: :model do

  describe "model validation" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    subject { build(:conversation, sender: sender, recipient: recipient) }

    it "has a valid factory" do
      expect(build(:conversation)).to be_valid
    end

    it "is not valid without sender" do
      expect(build(:conversation, sender: nil)).not_to be_valid
    end

    it "is not valid without recipient" do
      expect(build(:conversation, recipient: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }

    it { is_expected.to belong_to(:recipient) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe "scopes" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let(:conversation) { create(:conversation, sender: sender, recipient: recipient)}
    let(:other_conversation) { create(:conversation) }

    it "between" do
      expect(Conversation.between(sender.id, recipient.id)).to eq([conversation])
      expect(Conversation.between(sender.id, recipient.id)).not_to include(other_conversation)
    end
  end

  describe "instance methods" do
  end

  describe "class methods" do
    let!(:sender) { create(:user) }
    let!(:recipient) { create(:user) }
    let!(:other_recipient) { create(:user) }
    let!(:conversation) { create(:conversation, sender: sender, recipient: recipient) }

    context "create_of_find_conversation" do

      it "creates conversation" do
        expect{
          Conversation.create_or_find_conversation(sender.id, other_recipient.id)
        }.to change{Conversation.count}.by(1)
      end

      it "finds conversation" do 
        expect(
          Conversation.create_or_find_conversation(sender, recipient)
        ).to eq(conversation)
      end
    end
  end
end


