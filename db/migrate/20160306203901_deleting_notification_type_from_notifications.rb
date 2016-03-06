class DeletingNotificationTypeFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :notification_type
  end
end
