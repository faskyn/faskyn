require 'rails_helper'

feature "creating product" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:product) { create(:product, :product_with_nested_attrs, owner: user, name: "FaskynX") }

  scenario "successfully" do
    sign_in(user)
    visit new_product_company_path(product)
    fill_in "company[name]", with: "Faskyn Inc."
    fill_in "company[location]", with: "San Francisco, CA"
    fill_in "company[website]", with: "http://faskyn.com"
    select "May", from: "company[founded(2i)]"
    select "2015", from: "company[founded(1i)]"
    fill_in "company[team_size]", with: 2
    fill_in "company[engineer_number]", with: 1
    select "recurring revenue", from: "company[revenue_type]"
    select "< $100k", from: "company[revenue]"
    fill_in "company[investment]", with: 50000
    fill_in "company[investor]", with: "a16z, YC"
    click_on "Save Company"
    expect(page).to have_css(".flash-alert", text: "Company successfully created!")
    expect(page).to have_content("FaskynX")
    expect(page).to have_content("Faskyn Inc.")
  end
end