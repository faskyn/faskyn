class ProductInvitationPolicy < ApplicationPolicy

  def accept?
    user.present? && user == product_invitation.recipient
  end

  def destroy?
    user.present? && (user == product_invitation.recipient || user == product_invitation.sender)
  end

  private

    def product_invitation
      record
    end
end