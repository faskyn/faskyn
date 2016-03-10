class AddingNullConstraintsToNotifications < ActiveRecord::Migration
  def change
    change_column_null :notifications, :sender_id, false
    change_column_null :notifications, :recipient_id, false
    change_column_null :notifications, :notifiable_id, false
    change_column_null :notifications, :notifiable_type, false
    change_column_null :notifications, :action, false
  end
end
