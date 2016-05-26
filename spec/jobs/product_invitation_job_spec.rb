require "rails_helper"

describe ProductInvitationJob, type: :job do
  include ActiveJob::TestHelper
  
  describe "product invitation job" do
    before(:each) do
      clear_enqueued_jobs
      clear_performed_jobs
    end
    subject(:job) { described_class.perform_later(123) }

    it "invokes the mailer" do
      expect(ProductInvitationMailer).to receive_message_chain(:product_invitation_email, :deliver)
      perform_enqueued_jobs { job }
    end

    it "adds the job to the queue" do
      expect { job }.to have_enqueued_job(ProductInvitationJob)
    end

    it "is in default queue" do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end