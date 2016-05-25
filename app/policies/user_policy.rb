class UserPolicy < ApplicationPolicy

  def show?
    user.present?
  end

  def index?
    user.present?
  end

  def index_tasks?
    user.present? && user.id == record.id
  end

  def index_notifications?
    user.present? && user.id == record.id
  end

  def index_own_products?
    user.present? && user.id == record.id
  end
end