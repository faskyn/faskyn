class GroupInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(group_invitation)
    if group_invitation.group_invitable_type == "Product"
      GroupInvitationMailer.product_group_invitation_email(group_invitation).deliver
    elsif group_invitation.group_invitable_type == "ProductCustomer"
      GroupInvitationMailer.product_customer_group_invitation_email(group_invitation).deliver
    end
  end
end