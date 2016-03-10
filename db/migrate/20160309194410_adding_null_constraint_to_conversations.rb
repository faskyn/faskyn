class AddingNullConstraintToConversations < ActiveRecord::Migration
  def change
    change_column_null :conversations, :sender_id, false
    change_column_null :conversations, :recipient_id, false
  end
end
