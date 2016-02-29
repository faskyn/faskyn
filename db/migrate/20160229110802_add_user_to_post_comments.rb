class AddUserToPostComments < ActiveRecord::Migration
  def change
    add_column :post_comments, :user_id, :integer
    add_index :post_comments, :user_id
  end
end
