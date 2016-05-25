class ProductInvitationMailer < ActionMailer::Base

  def product_invitation_email(product_invitation)
    @product_invitation = product_invitation

    mail(from: "#{@product_invitation.sender.email}",
         to: "#{@product_invitation.recipient.email}",
         subject: "[Faskyn] #{@product_invitation.sender.full_name} invited you to join #{@product_invitation.product.name}!"
         )
  end
end