require "rails_helper"

RSpec.describe Notification, type: :model do

  describe "model validation" do

    it "has a valid factory" do
      expect(build_stubbed(:notification)).to be_valid
    end

    it "is vaild without checked_at" do
      expect(build_stubbed(:notification, checked_at: nil)).to be_valid
    end

    it "is invalid without sender" do
      expect(build_stubbed(:notification, sender_id: nil)).not_to be_valid
    end

    it "is invalid without recipient" do
      expect(build_stubbed(:notification, recipient_id: nil)).not_to be_valid
    end

    it "is invalid without notifiable_type" do
      expect(build_stubbed(:notification, notifiable_type: nil)).not_to be_valid
    end

    it "is invalid without notifiable_id" do
      expect(build_stubbed(:notification, notifiable_id: nil)).not_to be_valid
    end

    it "is invalid without action" do
      expect(build_stubbed(:notification, action: nil)).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:notifiable_type) }
    it { is_expected.to validate_presence_of(:notifiable_id) }
    it { is_expected.to validate_presence_of(:action) }

    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:recipient) }
    it { is_expected.to belong_to(:notifiable) } 

    it { is_expected.to callback(:send_notification).after(:create) }
  end

  describe "scopes" do
    let(:post) { create(:post) }
    let(:other_post) { create(:post) }
    let(:sender) { create(:user) }
    let(:other_user) {create(:user) }
    let(:chat_notification) { create(:notification, notifiable_type: "Message", checked_at: nil, sender: sender) }
    let(:other_chat_notification) { create(:notification, notifiable_type: "Message", checked_at: DateTime.now - 2) }
    let(:task_notification) { create(:notification, notifiable_type: "Task", sender: sender, checked_at: DateTime.now - 3) }
    let(:post_notification) { create(:notification, notifiable_type: "Post", checked_at: DateTime.now - 4, notifiable_id: post.id) }

    it "is not chat type(not_chat)" do
      expect(Notification.not_chat).to eq([task_notification, post_notification])
      expect(Notification.not_chat).not_to include(chat_notification)
    end

    it "is chat type(chat)" do
      expect(Notification.chat).to eq([chat_notification, other_chat_notification])
      expect(Notification.chat).not_to include(task_notification)
    end

    it "is task type(task)" do
      expect(Notification.task).to eq([task_notification])
      expect(Notification.task).not_to include(post_notification)
    end

    it "is post type(post)" do
      expect(Notification.post).to eq([post_notification])
      expect(Notification.post).not_to include(task_notification)
    end

    it "is unchecked(unchecked)" do
      expect(Notification.unchecked).to eq([chat_notification])
      expect(Notification.unchecked).not_to include(post_notification)
    end

    it "is checked(checked)" do
      expect(Notification.checked).to include(post_notification)
      expect(Notification.checked).not_to include(chat_notification)
    end

    it "belongs to this notifiable comments)" do
      expect(Notification.this_notifiable("Post", post.id)).to eq([post_notification])
      expect(Notification.this_notifiable("Post", other_post.id)).not_to include(post_notification)
    end

    it "belongs to this chat recipient(between_chat_recipient)" do
      expect(Notification.between_chat_recipient(sender.id)).to eq([chat_notification])
      expect(Notification.between_chat_recipient(sender.id)).not_to include(other_chat_notification, task_notification)
    end

    it "belongs to this other recipient(between_other_recipient)" do
      expect(Notification.between_other_recipient(sender.id)).to eq([task_notification])
      expect(Notification.between_other_recipient(sender.id)).not_to include(chat_notification)
    end
  end

  describe "instance methods" do
    let(:user) { create(:user) }
    let!(:other_notification) { create(:notification, checked_at: nil, notifiable_type: "Task", recipient: user) }
    let!(:chat_notification) { create(:notification, checked_at: nil, notifiable_type: "Message", recipient: user) }
    let(:notification) { create(:notification, checked_at: nil, recipient: user) }

    it "checks notification(check_notification)" do
      notification.check_notification
      expect(notification.checked_at).not_to eq(nil)
    end

    it "checked?" do
      notification_checked = create(:notification, checked_at: DateTime.now - 2)
      expect(notification.checked?).to eq(nil)
      expect(notification_checked.checked?).to_not eq(nil)
    end
  end

  describe "class methods" do
  end
end