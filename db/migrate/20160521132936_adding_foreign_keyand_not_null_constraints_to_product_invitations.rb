class AddingForeignKeyandNotNullConstraintsToProductInvitations < ActiveRecord::Migration
  def up
    add_foreign_key :product_invitations, :products
    add_foreign_key :product_invitations, :users, column: :recipient_id
    add_foreign_key :product_invitations, :users, column: :sender_id
    change_column_null :product_invitations, :product_id, false
    change_column_null :product_invitations, :sender_id, false
    change_column_null :product_invitations, :recipient_id, false
    change_column_null :product_invitations, :accepted, false
  end

  def down
    remove_foreign_key :product_invitations, :products
    remove_foreign_key :product_invitations, column: :recipient_id
    remove_foreign_key :product_invitations, column: :sender_id
    change_column_null :product_invitations, :product_id, true
    change_column_null :product_invitations, :sender_id, true
    change_column_null :product_invitations, :recipient_id, true
    change_column_null :product_invitations, :accepted, true
  end
end
