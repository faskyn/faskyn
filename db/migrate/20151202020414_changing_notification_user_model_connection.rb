class ChangingNotificationUserModelConnection < ActiveRecord::Migration
  def change
    add_column :notifications, :recipient_id, :integer
    remove_column :notifications, :sender
    add_column :notifications, :sender_id, :integer
    add_index :notifications, :sender_id
    add_index :notifications, :recipient_id
  end
end
