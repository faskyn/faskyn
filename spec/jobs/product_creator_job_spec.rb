require "rails_helper"

describe ProductCreatorJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  
  describe "product creator job" do
    let(:owner) { create(:user) }
    let!(:owner_profile) { create(:profile, user: owner) }
    let!(:product) { create(:product, :product_with_nested_attrs, owner: owner) }
    subject(:job) { described_class.set(wait: 2.days).perform_later(product.id) }

    it "invokes the mailer" do
      expect(ProductMailer).to receive_message_chain(:product_created, :deliver)
      perform_enqueued_jobs { job }
    end

    it "adds the job to the queue" do
      expect { job }.to have_enqueued_job(ProductCreatorJob)
    end

    it "is in default queue" do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end