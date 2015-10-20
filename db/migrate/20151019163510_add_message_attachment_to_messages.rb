class AddMessageAttachmentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_attachment, :string
    add_column :messages, :message_attachment_id, :string
  end
end
