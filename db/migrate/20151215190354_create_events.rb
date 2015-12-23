class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.string :title
      t.string :body
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps null: false
    end
  end
end
