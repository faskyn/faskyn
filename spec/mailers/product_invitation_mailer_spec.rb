require "rails_helper"

RSpec.describe ProductInvitationMailer, type: :mailer do
  describe "product_invitation_email" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let!(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, product: product, user: sender, role: "owner") }
    let!(:sender_profile) { create(:profile, user: sender) }
    let!(:recipient_profile) { create(:profile, user: recipient, first_name: "Peter", last_name: "Thief") }
    let!(:product_invitation) { create(:product_invitation, product: product, sender: sender, recipient: recipient, email: recipient.email) }
    let(:mail) { ProductInvitationMailer.product_invitation_email(product_invitation) }

    it "renders the subject" do
      expect(mail.subject).to eq("[Faskyn] #{sender.full_name} invited you to join #{product.name}!")
    end

    it "renders the recipient email" do
      expect(mail.to).to eq([recipient.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq([sender.email])
    end

    it "assigns recipient first_name" do
      expect(mail.body.encoded).to match(product_invitation.recipient.first_name)
    end

    it "assigns sender full_name" do
      expect(mail.body.encoded).to match(product_invitation.sender.full_name)
    end

    it "assigns the product name" do
      expect(mail.body.encoded).to match(product_invitation.product.name)
    end

    it "assigns product page" do
      expect(mail.body.encoded).to match("/products/#{product.id}")
    end
  end
end