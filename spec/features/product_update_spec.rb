require 'rails_helper'

feature "updating product" do
  let!(:industry) { create(:industry, name: "AI") }
  let!(:industry_2) { create(:industry, name: "Education") }
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:product) { create(:product, :product_with_nested_attrs, owner: user) }

  scenario "successfully" do
    sign_in(user)
    visit product_path(product)
    click_on "Edit Product"
    fill_in "product[product_customers_attributes][0][customer]", with: "Faskyn"
    fill_in "product[product_customers_attributes][0][usage]", with: "using the API to connect different services"
    click_on "Save Product"
    expect(page).to have_css(".flash-alert", text: "Product was successfully updated!")
    expect(page).to have_content("using the API to connect different services")
  end
end