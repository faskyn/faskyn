class CreateProductLeads < ActiveRecord::Migration
  def change
    create_table :product_leads do |t|
      t.references :product, index: true
      t.string :lead
      t.text :pitch
      t.timestamps null: false
    end
  end
end
