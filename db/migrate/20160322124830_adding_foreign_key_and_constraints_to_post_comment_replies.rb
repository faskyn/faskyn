class AddingForeignKeyAndConstraintsToPostCommentReplies < ActiveRecord::Migration
  def up
    change_column_null :post_comment_replies, :user_id, false
    change_column_null :post_comment_replies, :post_comment_id, false
    change_column_null :post_comment_replies, :body, false
    add_foreign_key :post_comment_replies, :post_comments
    add_foreign_key :post_comment_replies, :users
  end

  def down
    remove_foreign_key :post_comment_replies, :post_comments
    remove_foreign_key :post_comment_replies, :users
    change_column_null :post_comment_replies, :user_id, true
    change_column_null :post_comment_replies, :post_comment_id, true
    change_column_null :post_comment_replies, :body, true
  end
end
