require 'rails_helper'

feature "creating review" do
  let!(:profile) { create(:profile, user: user) }
  let(:user) { create(:user) }
  let(:owner) { create(:user) }
  let!(:product_user) { create(:product_user, user: owner, product: product, role: "owner") }
  let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: user) }
  let(:product) { create(:product, :product_with_nested_attrs) }
  let!(:product_customer) { create(:product_customer, product: product) }

  scenario "successfully", js: true do
    sign_in(user)
    visit product_product_customer_path(product, product_customer)
    within ".new-review-form" do
      fill_in "review[body]", with: "Super amazing product. We use it on daily basis."
    end
    click_on "Create Review"
    expect(page).to have_content("Super amazing product. We use it on daily basis.")
  end
end
