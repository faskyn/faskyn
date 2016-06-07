require "rails_helper"

describe ReviewWriterJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  
  describe "review writer job" do
    let(:owner) { create(:user) }
    let!(:owner_profile) { create(:profile, user: owner) }
    let(:reviewer) { create(:user) }
    let!(:recipient_profile) { create(:profile, user: reviewer, first_name: "Peter", last_name: "Thing") }
    let!(:product) { create(:product, :product_with_nested_attrs) }
    let!(:product_user) { create(:product_user, product: product, user: owner, role: "owner") }
    let!(:product_customer) { create(:product_customer, product: product) }
    let!(:review) { create(:review, user: reviewer, product_customer: product_customer) }
    subject(:job) { described_class.perform_later(review, product_customer) }

    it "invokes the mailer" do
      expect(ReviewWriterMailer).to receive_message_chain(:review_writer_email, :deliver)
      perform_enqueued_jobs { job }
    end

    it "adds the job to the queue" do
      expect { job }.to have_enqueued_job(ReviewWriterJob)
    end

    it "is in default queue" do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end