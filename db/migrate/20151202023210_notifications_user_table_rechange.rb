class NotificationsUserTableRechange < ActiveRecord::Migration
  def change
    remove_column :notifications, :recipient_id
    rename_column :notifications, :user_id, :recipient_id
  end
end
