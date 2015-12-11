class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user, only: [:other_notifications, :chat_notifications]

  def other_notifications
    @other_notifications = current_user.notifications.where.not('notifications.notification_type = ?', 'chat').limit(8).order(created_at: :desc)
    current_user.reset_new_other_notifications
  end

  def chat_notifications
    @chat_notifications = current_user.notifications.where('notifications.notification_type = ?', 'chat').limit(8).order(created_at: :desc)
    current_user.reset_new_chat_notifications
  end

  private

    def notification_params
      params.require(:notification).permit(:recipient_id, :sender_id, :notification_type, :checked_at)
    end
end
