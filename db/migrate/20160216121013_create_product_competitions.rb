class CreateProductCompetitions < ActiveRecord::Migration
  def change
    create_table :product_competitions do |t|
      t.references :product, index: true
      t.string :competitor
      t.text :diferentatior
      t.timestamps null: false
    end
  end
end
