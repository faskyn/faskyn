require 'rails_helper'

feature "creating task" do
  let!(:user) { create(:user) }
  let!(:profie) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, first_name: "Peter", last_name: "Thief", company: "PT") }
  let!(:other_user) { create(:user, profile: other_profile) }
  let!(:other_task) { create(:task, assigner: user, executor: other_user) }
  let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }
  
  scenario "successfully on index page", js: true do
    sign_in(user)
    visit user_tasks_path(user)   
    within ".task-header" do
      click_on "NEW TASK"
    end
    fill_in "task[task_name_company]", with: "Peter Thief PT"
    fill_in "task[content]", with: "do this task"
    fill_in "task[deadline]", with: "05/04/2030 09:00 AM"
    click_on "Create task"
    expect(page).to have_content("do this task")
  end

  scenario "successfully on other user's page", js: true do
    sign_in(user)
    visit user_path(other_user)   
    within ".task-header" do
      click_on "NEW TASK"
    end
    fill_in "task[content]", with: "do that task"
    fill_in "task[deadline]", with: "05/04/2030 09:00 AM"
    click_on "Create Task"
    expect(page).to have_content("do that task")
  end
end