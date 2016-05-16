class ForeignKeyIndexNullConstraintComments < ActiveRecord::Migration
  def up
    add_index :comments, [:commentable_id, :commentable_type]
    add_foreign_key :comments, :users
    change_column_null :comments, :user_id, false
    change_column_null :comments, :commentable_id, false
    change_column_null :comments, :commentable_type, false
    change_column_null :comments, :body, false
  end
  
  def down
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_foreign_key :comments, :users
    change_column_null :comments, :user_id, true
    change_column_null :comments, :commentable_id, true
    change_column_null :comments, :commentable_type, true
    change_column_null :comments, :body, true
  end
end
