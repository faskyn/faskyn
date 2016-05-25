require 'rails_helper'

feature "accepting product invitation" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, first_name: "John", last_name: "Doe") }
  let(:product) { create(:product, :product_with_nested_attrs) }
  let(:owner) { create(:user, email: "jackblack@gmail.com") }
  let!(:owner_profile) { create(:profile, user: owner, first_name: "Jack", last_name: "Black") }
  let!(:product_user) { create(:product_user, product: product, user: owner, role: "owner") }
  let!(:product_invitation) { create(:product_invitation, 
    product: product, sender: owner, recipient: user, email: user.email ) }

  scenario "successfully invites non faskyn user" do
    sign_in(user)
    visit product_path(product)
    click_on "Accept Invitation"
    expect(page).to have_content("Invitation accepted!")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Jack Black")
  end
end