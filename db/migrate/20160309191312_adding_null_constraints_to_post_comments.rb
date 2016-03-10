class AddingNullConstraintsToPostComments < ActiveRecord::Migration
  def change
    change_column_null :post_comments, :user_id, false
    change_column_null :post_comments, :post_id, false
    change_column_null :post_comments, :body, false
  end
end
