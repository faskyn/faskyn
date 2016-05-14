class CreateTableProductCustomers < ActiveRecord::Migration
  def change
    create_table :product_customers do |t|
      t.references :product, index: true
      t.string :customer 
      t.text :usage
      t.timestamps null: false
    end
  end
end
