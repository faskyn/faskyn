require "rails_helper"

describe ReviewsHelper do

  describe "twitter_product_share_text" do
    let(:owner) { create(:user) }
    let(:user) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs, owner: owner, name: "faskyn") }
    let(:product_customer) { create(:product_customer, product: product) }
    let!(:product_customer_user) { create(:product_customer_user, product_customer: product_customer, user: user) }
    let!(:review) { create(:review, user: user, product_customer: product_customer, body: "a" * 140) }

    it "returns the trimmed text" do
      #twitter API sets link character length to 23 regardless the length of the URL, so the full text length is (116 + 1 + 23 = 140)
      rest_length = 15 #  " + ..." on faskyn
      return_text = '"'+ "a" * (116 - rest_length) + '..." on faskyn'
      expect(twitter_review_share_text(review, product_customer)).to eq(return_text)
    end
  end
end