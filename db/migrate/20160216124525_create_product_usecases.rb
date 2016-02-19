class CreateProductUsecases < ActiveRecord::Migration
  def change
    create_table :product_usecases do |t|
      t.references :product, index: true
      t.string :example 
      t.text :details
      t.timestamps null: false
    end
  end
end
