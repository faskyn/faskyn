class AddingForeignKeyAndNullConstraintToReviews < ActiveRecord::Migration
  def up
    add_foreign_key :reviews, :product_customers
    add_foreign_key :reviews, :users
    change_column_null :reviews, :product_customer_id, false
    change_column_null :reviews, :user_id, false
    change_column_null :reviews, :body, false
  end

  def down
    remove_foreign_key :reviews, :product_customers
    remove_foreign_key :reviews, :users
    change_column_null :reviews, :product_customer_id, true
    change_column_null :reviews, :user_id, true
    change_column_null :reviews, :body, true
  end
end
