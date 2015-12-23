class ChangingColumnsInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :user_id, :recipient_id
    add_column :events, :sender_id, :integer
    add_index :events, :sender_id
  end
end
