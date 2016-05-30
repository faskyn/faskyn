class DropProductFeatures < ActiveRecord::Migration
  def change
    drop_table :product_features do |t|
      t.integer :product_id, null: false
      t.string :feature, null: false
      t.timestamps null: false
    end
  end
end
