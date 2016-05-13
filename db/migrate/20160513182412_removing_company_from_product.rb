class RemovingCompanyFromProduct < ActiveRecord::Migration
  def up
    change_column_null :products, :description, true
    change_column_null :products, :company, true
    remove_column :products, :company, :string
  end

  def down
    add_column :products, :company, :string
    change_column_null :products, :company, false
    change_column_null :products, :description, false
  end
end
