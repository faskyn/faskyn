require "rails_helper"

RSpec.describe NotificationSender, type: :model do

  let(:recipient) { create(:user) }
  let!(:chat_notification) { create(:notification, recipient: recipient, notifiable_type: "Message") }
  let!(:other_notification) { create(:notification, recipient: recipient, notifiable_type: "Product") }

  it "send increased" do
    notification_sender = NotificationSender.new(chat_notification)
    expect(notification_sender).to receive(:increase_new_chat_notifications)
    expect(notification_sender).to receive(:chat_notification_number_to_pusher)
    notification_sender.send_increased
  end
    
  it "increases new chat notifications" do
    notification_sender = NotificationSender.new(chat_notification)
    expect{ notification_sender.send(:increase_new_chat_notifications) }.to change{ recipient.new_chat_notification }.by(1)
  end

  it "increases new other notifications" do
    notification_sender = NotificationSender.new(other_notification)
    expect{ notification_sender.send(:increase_new_other_notifications) }.to change{ recipient.new_other_notification }.by(1)
  end

  it "chat notification number to pusher" do
    notification_sender = NotificationSender.new(chat_notification)
    number = recipient.new_chat_notification
    expect(Pusher).to receive(:trigger_async).with(('private-' + recipient.id.to_s), 'new_chat_notification', {number: number} )
    notification_sender.send(:chat_notification_number_to_pusher)
  end

  it "chat notification number to pusher" do
    notification_sender = NotificationSender.new(other_notification)
    number = recipient.new_other_notification
    expect(Pusher).to receive(:trigger_async).with(('private-' + recipient.id.to_s), 'new_other_notification', {number: number} )
    notification_sender.send(:other_notification_number_to_pusher)
  end
end

