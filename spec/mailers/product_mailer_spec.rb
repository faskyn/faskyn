require "rails_helper"

RSpec.describe ReviewWriterMailer, type: :mailer do

  describe "review writer email" do
    let(:owner) { create(:user) }
    let!(:owner_profile) { create(:profile, user: owner) }
    let!(:product) { create(:product, :product_with_nested_attrs, owner: owner) }
    let(:mail) { ProductMailer.product_created(product) }

    it "renders the subject" do
      expect(mail.subject).to eq("[Faskyn] Add company info to #{ product.name }")
    end

    it "renders the recipient email" do
      expect(mail.to).to eq([owner.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(['faskyn@gmail.com'])
    end

    it "assigns owner's first_name" do
      expect(mail.body.encoded).to match(owner.first_name)
    end

    it "assigns products's full_name" do
      expect(mail.body.encoded).to match(product.name)
    end

    it "assigns product customer page" do
      expect(mail.body.encoded).to match("/products/#{product.id}/company/new")
    end
  end
end