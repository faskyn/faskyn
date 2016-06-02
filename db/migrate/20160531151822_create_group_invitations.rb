class CreateGroupInvitations < ActiveRecord::Migration
  def change
    create_table :group_invitations do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :group_invitable_id
      t.string :group_invitable_type
      t.boolean :accepted, default: false
      t.timestamps null: false
    end
  end
end
