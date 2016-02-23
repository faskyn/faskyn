class UserPolicy < ApplicationPolicy

  def show_tasks?
    user.present? && user.id == record.id
  end

  def new_task?
    user.present? && user.id == record.id
  end

  def show_notifications?
    user.present? && user.id == record.id
  end

  def show_own_products?
    user.present? && user.id == record.id
  end

end