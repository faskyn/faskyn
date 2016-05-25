class CreateProductInvitation < ActiveRecord::Migration
  def change
    create_table :product_invitations do |t|
      t.references :product, index: true
      t.integer :recipient_id, index: true
      t.integer :sender_id, index: true
    end
  end
end
