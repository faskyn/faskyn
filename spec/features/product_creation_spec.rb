require 'rails_helper'

feature "creating product" do
  let!(:industry) { create(:industry, name: "AI") }
  let!(:industry_2) { create(:industry, name: "Education") }
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  scenario "successfully" do
    sign_in(user)
    visit new_product_path
    fill_in "product[name]", with: "Faskyn"
    select "AI", from: "product[industry_ids][]"
    select "Education", from: "product[industry_ids][]"
    fill_in "product[website]", with: "https://faskyn.com"
    fill_in "product[oneliner]", with: "Helping startups grow"
    fill_in "product[description]", with: "Share what your business does and connected with people who want it. Share what your business needs and connect to the ones who can offer a solution."
    fill_in "product[product_customers_attributes][0][customer]", with: "Fasykn"
    fill_in "product[product_customers_attributes][0][website]", with: "examplecustomer.com"
    fill_in "product[product_customers_attributes][0][usage]", with: "B2B distribution for their flagship product"
    click_on "Save product"
    expect(page).to have_content("Product got created!")
    expect(page).to have_content("Invite a New Member")
    click_on "Skip and go to product page"
    expect(page).to have_content("AI, Education")
    expect(page).to have_content("B2B distribution for their flagship product")
  end
end