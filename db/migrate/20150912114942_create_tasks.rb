class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer  "assigner_id"
      t.integer  "executor_id"
      t.string   "name"
      t.text     "content"
      t.datetime "deadline"
      t.datetime "completed_at"

      t.timestamps null: false
    end
    add_index :tasks, :assigner_id
    add_index :tasks, :executor_id
  end
end
