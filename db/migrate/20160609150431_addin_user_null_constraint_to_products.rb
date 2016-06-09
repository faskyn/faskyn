class AddinUserNullConstraintToProducts < ActiveRecord::Migration
  def up
    change_column_null :products, :user_id, false
  end

  def down
    change_column_null :products, :user_id, true
  end
end
