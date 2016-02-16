class ChangingReferenceForProducts < ActiveRecord::Migration
  def change
    rename_column :industries, :products_id, :product_id
    rename_column :product_features, :products_id, :product_id
  end
end
