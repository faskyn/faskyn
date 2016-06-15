require 'rails_helper'

feature "updating post" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:post) { create(:post, user: user, body: "original post body") }
  let(:other_user) { create(:user) }
  let!(:other_profile) { create(:profile, user: other_user) }
  let!(:other_post) {create(:post, user: other_user, body: "original other post body") }

  scenario "successfully", js: true do
    sign_in(user)
    visit root_path
    within "#post_#{post.id}" do
      page.find(".dropdown-toggle").click
    end
    click_on "Edit Post"
    within ".modal-body" do
      fill_in "post[body]", with: "new post body"
    end
    click_on "Update Post"
    expect(page).to have_content("new post body")
    expect(page).to_not have_content("original post body")
    page.find("#navbar-home").click
    expect(page).to have_content("new post body")
  end

  scenario "not allowed for others", js: true do
    sign_in(user)
    visit root_path
    within "#post_#{other_post.id}" do
      expect(page).to_not have_css(".dropdown-toggle")
    end
  end
end