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
    fill_in "product[company]", with: "Faskyn Inc."
    fill_in "product[oneliner]", with: "Helping startups grow"
    fill_in "product[description]", with: "Share what your business does and connected with people who want it. Share what your business needs and connect to the ones who can offer a solution."
    fill_in "product[product_features_attributes][0][feature]", with: "Share what you need and gather offers from potential suppliers."
    fill_in "product[product_usecases_attributes][0][example]", with: "enterprise"
    fill_in "product[product_usecases_attributes][0][detail]", with: "share what your business needs and find who can solve it"
    fill_in "product[product_competitions_attributes][0][competitor]", with: "AngelList"
    fill_in "product[product_competitions_attributes][0][differentiator]", with: "we encourage discussion and do manual targeting. we're focused on startups products instead of company profile."
    click_on "Save product"
    expect(page).to have_content("Product got created!")
    expect(page).to have_content("AI, Education")
    expect(page).to have_content("Share what you need and gather offers from potential suppliers.")
  end
end