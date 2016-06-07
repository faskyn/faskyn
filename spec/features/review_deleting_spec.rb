require 'rails_helper'

feature "creating review" do
  let!(:profile) { create(:profile, user: user) }
  let(:user) { create(:user) }
  let!(:owner_profile) { create(:profile, user: owner) }
  let(:owner) { create(:user) }
  let!(:product_user) { create(:product_user, user: owner, product: product, role: "owner") }
  let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: user) }
  let(:product) { create(:product, :product_with_nested_attrs) }
  let!(:product_customer) { create(:product_customer, product: product) }
  let!(:review) { create(:review, user: user, product_customer: product_customer, body: "original  review body") }

  scenario "successfully", js: true do
    sign_in(owner)
    visit product_product_customer_path(product, product_customer)
    within "#review_#{review.id}" do
      page.find(".review-deleting").click
    end
    within ".modal-footer" do
      click_on "Delete Review"
    end
    expect(page).to_not have_css(".review-body", text: "original review body")
  end
end