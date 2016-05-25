require 'rails_helper'

feature "creating product invitation" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:product) { create(:product, :product_with_nested_attrs) }
  let!(:product_user) { create(:product_user, product: product, user: user, role: "owner") }
  let(:existing_user) { create(:user, email: "jackblack@gmail.com") }
  let!(:existing_profile) { create(:profile, user: existing_user, first_name: "Jack", last_name: "Black") }

  scenario "successfully invites non faskyn user" do
    sign_in(user)
    visit product_path(product)
    click_on "Manage Members"
    fill_in "product_invitation[email]", with: "not_registered_yet@gmail.com"
    click_on "Invite a New Member"
    expect(page).to have_content("Invitation sent!")
    expect(page).to have_content("not_registered_yet@gmail.com")
    expect(page).to have_content("Pending")
  end

  scenario "successfully invites faskyn user" do
    sign_in(user)
    visit product_path(product)
    click_on "Manage Members"
    fill_in "product_invitation[email]", with: "jackblack@gmail.com"
    click_on "Invite a New Member"
    expect(page).to have_content("Invitation sent!")
    expect(page).to have_content("jackblack@gmail.com")
    expect(page).to have_content("Pending")
    expect(page).to have_content("Jack Black")
  end

end