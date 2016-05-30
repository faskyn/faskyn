class DropProductUsecases < ActiveRecord::Migration
  def change
    drop_table :product_usecases do |t|
      t.integer :product_id, null: false
      t.string :example, null: false
      t.text :detail, null: false
      t.timestamps null: false
    end
  end
end
