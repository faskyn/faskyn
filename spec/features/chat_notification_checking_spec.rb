require 'rails_helper'

feature "checking out chat notification" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user, first_name: "Jack", last_name: "Black") }
  let(:conversation) { create(:conversation, recipient: user, sender: other_user) }
  let!(:message) { create(:message, conversation: conversation, user: other_user, body: "original message body") }
  let!(:notification) { create(:notification, sender: other_user, recipient: user, notifiable_id: message.id, notifiable_type: "Message") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within '#chat-notify' do
      expect(page).to have_css("#chat-notifications", text: "1") 
    end
    within ".navbar-fixed-top" do
      page.find('[data-behavior="chat-notification-dropdown-list"]').click
    end
    within ".scrollable-bootstrap-menu" do
      page.find("li:first-child").click
    end
    expect(page).to have_content(other_profile.first_name)
    within '#chat-notify' do
      expect(page).to have_css("#chat-notifications", text: "")
    end
  end
end