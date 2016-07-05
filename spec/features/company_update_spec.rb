require 'rails_helper'

feature "creating product" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let(:product) { create(:product, :product_with_nested_attrs, owner: user, name: "FaskynX") }
  let!(:company) { create(:company, product: product) }

  scenario "successfully" do
    sign_in(user)
    visit edit_product_company_path(product)
    fill_in "company[team_size]", with: 4
    fill_in "company[engineer_number]", with: 3
    fill_in "company[investment]", with: 100000
    fill_in "company[investor]", with: "YCombinator"
    click_on "Save Company"
    expect(page).to have_css(".flash-alert", text: "Company successfully updated!")
    expect(page).to have_content("FaskynX")
    expect(page).to have_content("YCombinator")
  end
end