class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.integer :commentable_id
      t.string :commentable_type
      t.string :body
      t.timestamps null: false
    end
  end
end
