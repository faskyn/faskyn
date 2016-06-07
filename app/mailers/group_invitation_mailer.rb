class GroupInvitationMailer < ActionMailer::Base
  default from: 'faskyn@gmail.com'

  def product_group_invitation_email(group_invitation)
    @group_invitation = group_invitation

    mail(to: "#{@group_invitation.recipient.email}",
         subject: "[Faskyn] #{@group_invitation.sender.full_name} invited you to join a product!"
         )
  end

  def product_customer_group_invitation_email(group_invitation)
    @group_invitation = group_invitation

    mail(to: "#{@group_invitation.recipient.email}",
         subject: "[Faskyn] #{@group_invitation.sender.full_name} invited you to join a customer case!"
         ) 
  end
end