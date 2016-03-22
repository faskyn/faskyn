class CreatePostCommentReplies < ActiveRecord::Migration
  def change
    drop_table :post_comment_replies
    create_table :post_comment_replies do |t|
      t.references :user, index: true
      t.references :post_comment, index: true
      t.string :body
      t.timestamps null: false
    end
  end
end
