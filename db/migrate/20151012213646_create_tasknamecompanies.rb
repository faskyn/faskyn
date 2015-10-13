class CreateTasknamecompanies < ActiveRecord::Migration
  def change
    create_table :tasknamecompanies do |t|
      t.string :term
      t.integer :popularity

      t.timestamps null: false
    end
  end
end
