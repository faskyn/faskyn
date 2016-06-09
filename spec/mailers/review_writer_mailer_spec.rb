require "rails_helper"

RSpec.describe ReviewWriterMailer, type: :mailer do

  describe "review writer email" do
    let(:owner) { create(:user) }
    let!(:owner_profile) { create(:profile, user: owner) }
    let(:reviewer) { create(:user) }
    let!(:recipient_profile) { create(:profile, user: reviewer, first_name: "Peter", last_name: "Thing") }
    let!(:product) { create(:product, :product_with_nested_attrs, owner: owner) }
    let!(:product_customer) { create(:product_customer, product: product) }
    let!(:review) { create(:review, user: reviewer, product_customer: product_customer) }
    let(:mail) { ReviewWriterMailer.review_writer_email(review, product_customer) }

    it "renders the subject" do
      expect(mail.subject).to eq("[Faskyn] #{ review.user.full_name } wrote a review")
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

    it "assigns reviewer's full_name" do
      expect(mail.body.encoded).to match(review.user.full_name)
    end

    it "assigns the product customer" do
      expect(mail.body.encoded).to match(product_customer.customer)
    end

    it "assigns product customer page" do
      expect(mail.body.encoded).to match("/products/#{product.id}/product_customers/#{product_customer.id}")
    end
  end
end
