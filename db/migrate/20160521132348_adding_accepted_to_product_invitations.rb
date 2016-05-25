class AddingAcceptedToProductInvitations < ActiveRecord::Migration
  def up
    add_column :product_invitations, :accepted, :boolean, default: false
  end

  def down
    remove_column :product_invitations, :accepted, :booleean, default: nil
  end
end
