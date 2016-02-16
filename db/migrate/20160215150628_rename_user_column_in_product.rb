class RenameUserColumnInProduct < ActiveRecord::Migration
  def change
    rename_column :products, :users_id, :user_id
  end
end
