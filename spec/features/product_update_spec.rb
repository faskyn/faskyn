require 'rails_helper'

feature "creating product" do
  let!(:industry) { create(:industry, name: "AI") }
  let!(:industry_2) { create(:industry, name: "Education") }
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }
  let!(:product) { create(:product, :product_with_nested_attrs, user: user) }

  scenario "successfully" do
    sign_in(user)
    visit product_path(product)
    click_on "Edit Product"
    fill_in "product[product_usecases_attributes][0][example]", with: "enterprise"
    fill_in "product[product_usecases_attributes][0][detail]", with: "share what your business needs and find who can solve it"
    click_on "Save product"
    expect(page).to have_content("Product was successfully updated!")
    expect(page).to have_content("share what your business needs and find who can solve it")
  end
end