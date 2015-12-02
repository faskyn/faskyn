class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :body
      t.string :sender
      t.string :type

      t.timestamps null: false
    end
    add_index :notifications, :user_id
  end
end
