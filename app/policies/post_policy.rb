class PostPolicy < ApplicationPolicy
  def index?
    user.present? && user.profile.present?
  end

  def show?
    user.present? && user.profile.present?
  end

  def new?
    user.present? && user.profile.present?
  end

  def create?
    user.present? && user.profile.present?
  end

  def edit?
    user.present? && user == post.user
  end

  def update?
    user.present? && user == post.user
  end

  def delete?
    user.present? && user == post.user
  end

  def destroy?
    user.present? && user == post.user
  end

  private

    def post
      record
    end
end