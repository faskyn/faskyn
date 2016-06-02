class GroupInvitationMailer < ActionMailer::Base

  def product_group_invitation_email(group_invitation)
    @group_invitation = group_invitation

    mail(from: "#{@group_invitation.sender.email}",
         to: "#{@group_invitation.recipient.email}",
         subject: "[Faskyn] #{@group_invitation.sender.full_name} invited you to join #{@group_invitation.group_invitable.name}!"
         )
  end

  def product_customer_group_invitation_email(group_invitation)
    @group_invitation = group_invitation

    mail(from: "#{@group_invitation.sender.email}",
         to: "#{@group_invitation.recipient.email}",
         subject: "[Faskyn] #{@group_invitation.sender.full_name} invited you to write a reference for #{@group_invitation.group_invitable.product.name}!"
         ) 
  end
end