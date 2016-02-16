class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.references :products, index: true
      t.string :name
      t.timestamps null: false
    end
  end
end
