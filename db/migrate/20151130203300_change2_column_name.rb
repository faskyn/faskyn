class Change2ColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :new_notifications, :new_chat_notification
    add_column :users, :new_other_notification, :integer, default: 0
  end
end
