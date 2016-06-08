class AddingWebsiteNullConstraintToProductCustomers < ActiveRecord::Migration
  def up
    change_column_null :product_customers, :website, false
  end

  def down
    change_column_null :product_customers, :website, true
  end
end
