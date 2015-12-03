class AddingCheckedAtColumnToBothNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :checked_at, :datetime
  end
end
