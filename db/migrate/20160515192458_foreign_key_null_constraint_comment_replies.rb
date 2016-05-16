class ForeignKeyNullConstraintCommentReplies < ActiveRecord::Migration
  def up
    add_foreign_key :comment_replies, :users
    add_foreign_key :comment_replies, :comments
    change_column_null :comment_replies, :user_id, false
    change_column_null :comment_replies, :comment_id, false
    change_column_null :comment_replies, :body, false
  end
  
  def down
    remove_foreign_key :comment_replies, :users
    remove_foreign_key :comment_replies, :comments
    change_column_null :comment_replies, :user_id, true
    change_column_null :comment_replies, :comment_id, true
    change_column_null :comment_replies, :body, true
  end
end
