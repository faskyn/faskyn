class AddingNullTimeConstraintToProductUsers < ActiveRecord::Migration
  def up
    change_column_null :product_users, :created_at, false
    change_column_null :product_users, :updated_at, false
  end

  def down
    change_column_null :product_users, :created_at, true
    change_column_null :product_users, :updated_at, true
  end
end
