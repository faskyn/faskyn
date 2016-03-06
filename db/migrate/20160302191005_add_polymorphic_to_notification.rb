class AddPolymorphicToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
    add_column :notifications, :action, :string
  end
end
