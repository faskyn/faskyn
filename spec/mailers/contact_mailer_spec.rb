require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "task_created" do
    let(:contact) { create(:contact) }
    let(:mail) { ContactMailer.contact_email(contact.name, contact.email, contact.comment) }

    it "renders the subject" do
      expect(mail.subject).to eq("Contact form message")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq(["faskyn@gmail.com"])
    end

    it "renders the sender email" do
      expect(mail.from).to eq([contact.email])
    end

    it "assigns contact name" do
      expect(mail.body.encoded).to match(contact.name)
    end

    it "assigns email" do
      expect(mail.body.encoded).to match(contact.email)
    end

    it "assigns content" do
      expect(mail.body.encoded).to match(contact.comment)
    end
  end
end