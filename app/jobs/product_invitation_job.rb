class ProductInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(product_invitation)
    ProductInvitationMailer.product_invitation_email(product_invitation).deliver
  end
end