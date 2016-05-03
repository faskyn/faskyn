require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "task_created" do
    let(:assigner) { create(:user) }
    let(:executor) { create(:user) }
    let!(:assigner_profile) { create(:profile, user: assigner) }
    let!(:executor_profile) { create(:profile, user: executor, first_name: "Peter", last_name: "Thief") }
    let(:task) { create(:task, assigner: assigner, executor: executor, content: "taskmailer test") }
    let(:mail) { TaskMailer.task_created(task, executor, assigner) }

    it "renders the subject" do
      expect(mail.subject).to eq("[Faskyn] New task from #{assigner.profile.full_name}")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([executor.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["faskyn@gmail.com"])
    end

    it "assigns executor first_name" do
      expect(mail.body.encoded).to match(executor_profile.first_name)
    end

    it "assigns assigner full name" do
      expect(mail.body.encoded).to match(assigner_profile.full_name)
    end

    it "assigns executor path" do
      expect(mail.body.encoded).to match("/users/#{assigner.id}")
    end
  end
end