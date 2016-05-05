require 'rails_helper'

feature "updating task" do
  let!(:user) { create(:user) }
  let!(:profie) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, first_name: "Peter", last_name: "Thief", company: "PT") }
  let!(:other_user) { create(:user, profile: other_profile) }
  let!(:task) { create(:task, assigner: user, executor: other_user, content: "original content") }
  let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }
  
  scenario "successfully on index page", js: true do
    sign_in(user)
    visit user_tasks_path(user)   
    page.find("#task-change-#{task.id}").click
    click_on "Edit Task"
    fill_in "task[content]", with: "updated content"
    click_on "Update task"
    expect(page).to have_content("updated content")
  end

  scenario "successfully on other user's page", js: true do
    sign_in(user)
    visit user_path(other_user)
    page.find("#task-change-#{task.id}").click
    click_on "Edit Task"
    fill_in "task[content]", with: "updated content"
    click_on "Update task"
    expect(page).to have_content("updated content")
    expect(page).to_not have_content("original content")
  end
end