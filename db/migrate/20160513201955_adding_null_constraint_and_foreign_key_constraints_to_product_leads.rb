class AddingNullConstraintAndForeignKeyConstraintsToProductLeads < ActiveRecord::Migration
  def up
    add_foreign_key :product_leads, :products
    change_column_null :product_leads, :product_id, false
    change_column_null :product_leads, :lead, false
    change_column_null :product_leads, :pitch, false
  end

  def down
    remove_foreign_key :product_leads, :products
    change_column_null :product_leads, :product_id, true
    change_column_null :product_leads, :lead, true
    change_column_null :product_leads, :pitch, true
  end
end
