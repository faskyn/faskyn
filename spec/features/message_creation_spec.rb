require 'rails_helper'

feature "creating message" do
  let(:sender) { create(:user) }
  let!(:sender_profile) { create(:profile, user: sender) }
  let(:recipient) {create(:user) }
  let!(:recipient_profile) { create(:profile, user: recipient) }
  let!(:task) { create(:task, assigner: sender, executor: recipient) }
  let!(:conversation) { create(:conversation, sender: sender, recipient: recipient) }

  scenario "successfully", js: true do
    sign_in(sender)
    visit user_path(recipient)
    fill_in "message[body]", with: "new body"
    find("#message_body").native.send_keys(:return)
    within ".chatboxcontent" do
      expect(page).to have_content("new body")
    end
    within "#message_body" do
      expect(page).to_not have_content("new body")
    end
  end
end