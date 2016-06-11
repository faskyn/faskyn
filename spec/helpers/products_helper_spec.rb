require "rails_helper"

describe ProductsHelper do

  describe "twitter_product_share_text" do
    let(:user) { create(:user) }
    let!(:product) { create(:product, :product_with_nested_attrs, owner: user, oneliner: "a" * 140) }

    it "returns the trimmed text" do
      #twitter API sets link character length to 23 regardless the length of the URL, so the full text length is (116 + 1 + 23 = 140)
      return_text = product.name + ": " + "a" * (116 - product.name.length - 5) + "..."
      expect(twitter_product_share_text(product)).to eq(return_text)
    end
  end
end