class ChangeLinksColumnTypeInMessages < ActiveRecord::Migration
  def self.up
    change_column :messages, :link, :text
  end

  def self.down
    change_column :messages, :link, :string
  end
end
