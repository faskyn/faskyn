class TaskPolicy < ApplicationPolicy

  def create?
    user.present?
  end

  def edit?
    user.present? && (user.id == task.assigner_id || user.id == task.executor_id)
  end

  def update?
    user.present? && (user.id == task.assigner_id || user.id == task.executor_id)
  end

  def destroy?
    user.present? && (user.id == task.assigner_id || user.id == task.executor_id)
  end

  def complete?
    user.present? && (user.id == task.assigner_id || user.id == task.executor_id)
  end

  def uncomplete?
    user.present? && (user.id == task.assigner_id || user.id == task.executor_id)
  end

  private

    def task
      record
    end
end