require 'rails_helper'

feature "creating task" do
  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, first_name: "Peter", last_name: "Thief", company: "PT", user: other_user) }
  let!(:other_user) { create(:user) }
  let!(:other_task) { create(:task, assigner: user, executor: other_user) }
  let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }
  
  scenario "successfully on index page", js: true do
    sign_in(user)
    visit user_tasks_path(user)   
    within ".title-row" do
      click_on "NEW MESSAGE"
    end
    fill_in "task[task_name_company]", with: "Peter Thief PT"
    fill_in "task[content]", with: "do this task"
    click_on "Create Message"
    expect(page).to have_content("do this task")
    expect(page).to have_css(".flash-alert", text: "Message sent!")
  end

  scenario "successfully on other user's page", js: true do
    sign_in(user)
    visit user_path(other_user)   
    within ".title-row" do
      click_on "NEW MESSAGE"
    end
    fill_in "task[content]", with: "do that task"
    click_on "Create Message"
    expect(page).to have_content("do that task")
    expect(page).to have_css(".flash-alert", text: "Message sent!")
  end
end