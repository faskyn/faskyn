class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :users, index: true
      t.string :company
      t.string :website
      t.string :oneliner
      t.text :description
      t.text :usecase
      t.text :competition
      t.timestamps null: false
    end
  end
end
