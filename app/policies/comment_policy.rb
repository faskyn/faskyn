class CommentPolicy < ApplicationPolicy
 
  def create?
    user.present? && user.profile.present?
  end

  def update?
    user.present? && user == comment.user
  end

  def destroy?
    user.present? && user == comment.user
  end

  private

    def comment
      record
    end
end