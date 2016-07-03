class AddingConstraintsToCompany < ActiveRecord::Migration
  def up
    add_foreign_key :companies, :products
    change_column_null :companies, :product_id, false
    change_column_null :companies, :name, false
    change_column_null :companies, :location, false
    change_column_null :companies, :founded, false
    change_column_null :companies, :team_size, false
    change_column_null :companies, :engineer_number, false
    change_column_null :companies, :investment, false
    change_column_null :companies, :investor, false
    change_column_null :companies, :revenue_type, false
    change_column_null :companies, :revenue, false
  end

  def down
    remove_foreign_key :companies, :products
    change_column_null :companies, :product_id, true
    change_column_null :companies, :name, true
    change_column_null :companies, :location, true
    change_column_null :companies, :founded, true
    change_column_null :companies, :team_size, true
    change_column_null :companies, :engineer_number, true
    change_column_null :companies, :investment, true
    change_column_null :companies, :investor, true
    change_column_null :companies, :revenue_type, true
    change_column_null :companies, :revenue, true
  end
end
