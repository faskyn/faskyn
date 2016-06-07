require "rails_helper"

RSpec.describe GroupInvitationMailer, type: :mailer do

  describe "group invitation emails" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let!(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, product: product, user: sender, role: "owner") }
    let!(:sender_profile) { create(:profile, user: sender) }
    let!(:recipient_profile) { create(:profile, user: recipient, first_name: "Peter", last_name: "Thief") }

    describe "product group invitation email" do
      let(:group_invitation) { create(:group_invitation, group_invitable: product, sender: sender, recipient: recipient, email: recipient.email) }
      let(:mail) { GroupInvitationMailer.product_group_invitation_email(group_invitation) }

      it "renders the subject" do
        expect(mail.subject).to eq("[Faskyn] #{ group_invitation.sender.full_name } invited you to join a product!")
      end

      it "renders the recipient email" do
        expect(mail.to).to eq([recipient.email])
      end

      it "renders the sender email" do
        expect(mail.from).to eq(["faskyn@gmail.com"])
      end

      it "assigns recipient first_name" do
        expect(mail.body.encoded).to match(group_invitation.recipient.first_name)
      end

      it "assigns sender full_name" do
        expect(mail.body.encoded).to match(group_invitation.sender.full_name)
      end

      it "assigns the product name" do
        expect(mail.body.encoded).to match(group_invitation.group_invitable.name)
      end

      it "assigns product page" do
        expect(mail.body.encoded).to match("/products/#{product.id}")
      end
    end

    describe "product customer group invitation email" do
      let(:product_customer) { create(:product_customer, product: product) }
      let(:group_invitation) { create(:group_invitation, group_invitable: product_customer, sender: sender, recipient: recipient, email: recipient.email) }
      let(:mail) { GroupInvitationMailer.product_customer_group_invitation_email(group_invitation) }

      it "renders the subject" do
        expect(mail.subject).to eq("[Faskyn] #{ group_invitation.sender.full_name } invited you to join a customer case!")
      end

      it "renders the recipient email" do
        expect(mail.to).to eq([recipient.email])
      end

      it "renders the sender email" do
        expect(mail.from).to eq(["faskyn@gmail.com"])
      end

      it "assigns recipient first_name" do
        expect(mail.body.encoded).to match(group_invitation.recipient.first_name)
      end

      it "assigns sender full_name" do
        expect(mail.body.encoded).to match(group_invitation.sender.full_name)
      end

      it "assigns the product name" do
        expect(mail.body.encoded).to match(group_invitation.group_invitable.product.name)
      end

      it "assigns product page" do
        expect(mail.body.encoded).to match("/products/#{product.id}/product_customers/#{product_customer.id}")
      end
    end
  end
end