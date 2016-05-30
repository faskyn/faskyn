class DropProductCompetitions < ActiveRecord::Migration
  def change
    drop_table :product_competitions do |t|
      t.integer :product_id, null: false
      t.string :competitor, null: false
      t.text :differentiator, null: false
      t.timestamps null: false
    end
  end
end
