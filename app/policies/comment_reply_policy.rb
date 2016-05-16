class CommentReplyPolicy < ApplicationPolicy

  def create?
    user.present? && user.profile.present?
  end

  def update?
    user.present? && user == comment_reply.user
  end

  def destroy?
    user.present? && user == comment_reply.user
  end

  private

    def comment_reply
      record
    end
end