class GroupInvitationPolicy < ApplicationPolicy

  def accept?
    user.present? && user == group_invitation.recipient
  end

  def destroy?
    user.present? && (user == group_invitation.recipient || user == group_invitation.sender)
  end

  private

    def group_invitation
      record
    end
end