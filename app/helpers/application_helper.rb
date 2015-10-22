module ApplicationHelper

  def has_profile?
    current_user.profile
  end

  def if_tasks_any?
    current_user.executed_tasks.any? || current_user.assigned_tasks.any?
  end

end
