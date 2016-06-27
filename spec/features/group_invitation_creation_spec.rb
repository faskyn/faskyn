require 'rails_helper'

feature "creating product group invitation" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:product) { create(:product, :product_with_nested_attrs, owner: user) }
  let(:existing_user) { create(:user, email: "jackblack@gmail.com") }
  let!(:existing_profile) { create(:profile, user: existing_user, first_name: "Jack", last_name: "Black") }
  let!(:product_customer) { create(:product_customer, product: product) }

  scenario "successfully invites non faskyn user to join as product member" do
    sign_in(user)
    visit product_product_owner_panels_path(product)
    within ".product-group-invitation-form" do
      fill_in "group_invitation[email]", with: "not_registered_yet@gmail.com"
    end
    click_on "Invite Member"
    expect(page).to have_css(".flash-alert", "Invitation sent!")
    expect(page).to have_css("td", text: "not_registered_yet@gmail.com")
    expect(page).to have_content("Pending")
  end

  scenario "successfully invites faskyn user to join as product member" do
    sign_in(user)
    visit product_product_owner_panels_path(product)
    within ".product-group-invitation-form" do
      fill_in "group_invitation[email]", with: "jackblack@gmail.com"
    end
    click_on "Invite Member"
    expect_page_registered_user
  end

  scenario "successfully invites non faskyn user to join as product customer referencer" do
    sign_in(user)
    visit product_product_owner_panels_path(product)
    within ".product-customer-group-invitation-form" do
      fill_in "group_invitation[email]", with: "not_registered_yet_other@gmail.com"
    end
    click_on "Invite Referencer"
    expect(page).to have_css(".flash-alert", text: "Invitation sent!")
    expect(page).to have_css("td", text: "not_registered_yet_other@gmail.com")
    expect(page).to have_css("td", text: "Pending")
  end

  scenario "successfully invites faskyn user to join as product customer referencer" do
    sign_in(user)
    visit product_product_owner_panels_path(product)
    within ".product-customer-group-invitation-form" do
      fill_in "group_invitation[email]", with: "jackblack@gmail.com"
    end
    click_on "Invite Referencer"
    expect_page_registered_user
  end

  def expect_page_registered_user
    expect(page).to have_css(".flash-alert", text: "Invitation sent!")
    expect(page).to have_css("td", text: "jackblack@gmail.com")
    expect(page).to have_css("td", text: "Pending")
    expect(page).to have_css("td", text: "Jack Black")
  end
end  