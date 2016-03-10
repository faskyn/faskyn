class AddingNullConstraintToMessages < ActiveRecord::Migration
  def change
    change_column_null :messages, :user_id, false
    change_column_null :messages, :conversation_id, false
  end
end
