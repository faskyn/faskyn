class StoreMetadata < ActiveRecord::Migration
  def change
    add_column :messages, :message_attachment_filename, :string
    add_column :messages, :message_attachment_size, :integer
    add_column :messages, :message_attachment_content_type, :string
  end
end
