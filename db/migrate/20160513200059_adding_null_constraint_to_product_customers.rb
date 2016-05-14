class AddingNullConstraintToProductCustomers < ActiveRecord::Migration
  def up
    add_foreign_key :product_customers, :products
    change_column_null :product_customers, :product_id, false
    change_column_null :product_customers, :customer, false
    change_column_null :product_customers, :usage, false
  end

  def down
    remove_foreign_key :product_customers, :products
    change_column_null :product_customers, :product_id, true
    change_column_null :product_customers, :customer, true
    change_column_null :product_customers, :usage, true
  end
end
