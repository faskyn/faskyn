class CreateCommentReplies < ActiveRecord::Migration
  def change
    create_table :comment_replies do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.string :body
      t.timestamps null: false
    end
  end
end
