class PostCommentReplyPolicy < ApplicationPolicy

  def create?
    user.present? && user.profile.present?
  end

  def update?
    user.present? && user == post_comment_reply.user
  end

  def destroy?
    user.present? && user == post_comment_reply.user
  end

  private

    def post_comment_reply
      record
    end
end