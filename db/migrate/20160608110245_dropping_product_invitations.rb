class DroppingProductInvitations < ActiveRecord::Migration
  def change
    drop_table :product_invitations do |t|
      t.integer :product_id, null: false
      t.integer :sender_id, null: false
      t.integer :recipient_ud, null: false
      t.boolean :accepted, default: false, null: false
      t.timestamps null: false
    end
  end
end
