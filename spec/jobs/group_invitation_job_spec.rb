require "rails_helper"

describe GroupInvitationJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  
  describe "product group invitation job" do
    let(:recipient) { create(:user) }
    let(:sender) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:owner) { create(:product_user, product: product, role: "owner", user: sender) }
    let!(:group_invitation) { create(:group_invitation, group_invitable: product,
      sender: sender, recipient: recipient, email: recipient.email) }
    subject(:job) { described_class.perform_later(group_invitation.id) }

    it "invokes the mailer" do
      expect(GroupInvitationMailer).to receive_message_chain(:product_group_invitation_email, :deliver)
      perform_enqueued_jobs { job }
    end

    it "adds the job to the queue" do
      expect { job }.to have_enqueued_job(GroupInvitationJob)
    end

    it "is in default queue" do
      expect(described_class.new.queue_name).to eq('default')
    end
  end

  describe "product customer group invitation job" do
    let(:recipient) { create(:user) }
    let(:sender) { create(:user) }
    let(:product) { create(:product, :product_with_nested_attrs) }
    let!(:owner) { create(:product_user, product: product, role: "owner", user: sender) }
    let(:product_customer) { create(:product_customer, product: product) }
    let!(:group_invitation) { create(:group_invitation, group_invitable: product_customer,
      sender: sender, recipient: recipient, email: recipient.email) }
    subject(:job) { described_class.perform_later(group_invitation) }

    it "invokes the mailer" do
      expect(GroupInvitationMailer).to receive_message_chain(:product_customer_group_invitation_email, :deliver)
      perform_enqueued_jobs { job }
    end

    it "adds the job to the queue" do
      expect { job }.to have_enqueued_job(GroupInvitationJob)
    end

    it "is in default queue" do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end