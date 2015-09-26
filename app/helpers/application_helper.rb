module ApplicationHelper

  def has_profile?
    current_user.profile.present?
  end

end
