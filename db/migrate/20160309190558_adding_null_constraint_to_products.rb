class AddingNullConstraintToProducts < ActiveRecord::Migration
  def change
    change_column_null :products, :user_id, false
    change_column_null :products, :name, false
    change_column_null :products, :company, false
    change_column_null :products, :website, false
    change_column_null :products, :oneliner, false
    change_column_null :products, :description, false
  end
end