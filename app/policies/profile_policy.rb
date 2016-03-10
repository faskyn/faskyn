class ProfilePolicy < ApplicationPolicy

  def show?
    user.present?
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def edit?
    user.present? && user == profile.user
  end

  def update?
    user.present? && user == profile.user
  end

  def add_socials?
    user.present? && user == profile.user
  end

  private

    def profile
      record
    end
end