class AddingNullConstAndForeignKeyToProductCustomerUsers < ActiveRecord::Migration
  def up
    add_foreign_key :product_customer_users, :product_customers
    add_foreign_key :product_customer_users, :users
    change_column_null :product_customer_users, :product_customer_id, false
    change_column_null :product_customer_users, :user_id, false
  end

  def down
    remove_foreign_key :product_customer_users, :product_customers
    remove_foreign_key :product_customer_users, :users
    change_column_null :product_customer_users, :product_customer_id, true
    change_column_null :product_customer_users, :user_id, true
  end
end
