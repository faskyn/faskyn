class AddingLinksToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :link, :string
  end
end
