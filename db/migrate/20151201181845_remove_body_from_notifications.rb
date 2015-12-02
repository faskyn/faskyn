class RemoveBodyFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :body, :string
  end
end
