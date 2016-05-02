class PostCommentPolicy < ApplicationPolicy
 
  def create?
    user.present? && user.profile.present?
  end

  def update?
    user.present? && user == post_comment.user
  end

  def destroy?
    user.present? && user == post_comment.user
  end

  private

    def post_comment
      record
    end
end