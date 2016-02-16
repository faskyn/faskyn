class RemoveProductColumnFromIndustry < ActiveRecord::Migration
  def change
    remove_index :industries, :product_id
    remove_column :industries, :product_id
  end
end
