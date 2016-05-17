require 'rails_helper'

feature "checking out post notification" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:post) { create(:post, user: user, body: "original post body") }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user, first_name: "Jack", last_name: "Black") }
  let!(:notification) { create(:notification, sender: other_user, recipient: user, notifiable_id: post.id, notifiable_type: "Post") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within '#other-notify' do
      expect(page).to have_css("#other-notifications", text: "1") 
    end
    within ".navbar-fixed-top" do
      page.find('[data-behavior="other-notification-dropdown-list"]').click
    end
    within ".scrollable-bootstrap-menu" do
      page.find("li:first-child").click
    end
    expect(page).to have_content("SHARE")
    within '#other-notify' do
      expect(page).to have_css("#other-notifications", text: "")
    end
  end
end