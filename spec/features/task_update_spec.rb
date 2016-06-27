require 'rails_helper'

feature "updating task" do
  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, first_name: "Peter", last_name: "Thief", company: "PT", user: other_user) }
  let!(:other_user) { create(:user) }
  let!(:task) { create(:task, assigner: user, executor: other_user, content: "original content") }
  let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }
  
  scenario "successfully on index page", js: true do
    sign_in(user)
    visit user_tasks_path(user)   
    submit_paste(content: "updated_content")
  end

  scenario "successfully on other user's page", js: true do
    sign_in(user)
    visit user_path(other_user)
    submit_paste(content: "updated_content")
  end

  def submit_paste(content:)
    page.find("#task-change-#{task.id}").click
    click_on "Edit Message"
    fill_in "task[content]", with: content
    click_on "Update Message"
    expect(page).to have_content(content)
  end
end