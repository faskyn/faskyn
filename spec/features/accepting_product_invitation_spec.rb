require 'rails_helper'

feature "accepting product group invitation" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, first_name: "John", last_name: "Doe") }
  let(:product) { create(:product, :product_with_nested_attrs, owner: owner) }
  let(:owner) { create(:user, email: "jackblack@gmail.com") }
  let!(:owner_profile) { create(:profile, user: owner, first_name: "Jack", last_name: "Black") }
  let!(:group_invitation) { create(:group_invitation, 
    group_invitable: product, sender: owner, recipient: user, email: user.email ) }

  scenario "successfully" do
    sign_in(user)
    visit product_path(product)
    click_on "Accept Invitation"
    expect(page).to have_css(".flash-alert", text: "Invitation accepted!")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Jack Black")
  end
end

feature "accepting product customer group invitation" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, first_name: "John", last_name: "Doe") }
  let(:product) { create(:product, :product_with_nested_attrs, owner: owner) }
  let(:owner) { create(:user, email: "jackblack@gmail.com") }
  let!(:owner_profile) { create(:profile, user: owner, first_name: "Jack", last_name: "Black") }
  let!(:product_customer) { create(:product_customer, product: product, customer: "Best Inc") }
  let!(:group_invitation) { create(:group_invitation, 
    group_invitable: product_customer, sender: owner, recipient: user, email: user.email ) }

  scenario "successfully" do
    sign_in(user)
    visit product_product_customer_path(product, product_customer)
    click_on "Accept Invitation"
    expect(page).to have_css(".flash-alert", text: "Invitation accepted!")
    expect(page).to have_content("Best Inc")
  end
end