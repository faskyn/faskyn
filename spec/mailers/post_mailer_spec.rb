require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe "post_created" do
    let(:writer) { create(:user) }
    let(:reader) { create(:user) }
    let!(:writer_profile) { create(:profile, user: writer) }
    let!(:reader_profile) { create(:profile, user: reader, first_name: "Peter", last_name: "Thief") }
    let(:post) { create(:post, user: writer, body: "postmailer test") }
    let(:mail) { PostMailer.post_created(post, writer, reader) }

    it "renders the subject" do
      expect(mail.subject).to eq("[Faskyn] New post from #{writer.profile.full_name}")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([reader.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq([writer.email])
    end

    it "assigns reader first_name" do
      expect(mail.body.encoded).to match(reader_profile.first_name)
    end

    it "assigns writer full name" do
      expect(mail.body.encoded).to match(writer_profile.full_name)
    end

    it "assigns reader path" do
      expect(mail.body.encoded).to match("/posts")
    end
  end
end