class AddingForeignKeyAndNullConstraintToProductUsers < ActiveRecord::Migration
  def up
    add_foreign_key :product_users, :products
    add_foreign_key :product_users, :users
    change_column_null :product_users, :product_id, false
    change_column_null :product_users, :user_id, false
    change_column_null :product_users, :role, false
  end

  def down
    remove_foreign_key :product_users, :products
    remove_foreign_key :product_users, :users
    change_column_null :product_users, :product_id, true
    change_column_null :product_users, :user_id, true
    change_column_null :product_users, :role, true
  end
end
