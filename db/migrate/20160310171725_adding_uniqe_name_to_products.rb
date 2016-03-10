class AddingUniqeNameToProducts < ActiveRecord::Migration
  def up
    add_index :products, :name, unique: true
  end

  def down
    remove_index :products, :name
  end
end
