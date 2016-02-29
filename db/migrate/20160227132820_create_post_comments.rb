class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.references :post, index: true
      t.string :body
      t.timestamps null: false
    end
  end
end
