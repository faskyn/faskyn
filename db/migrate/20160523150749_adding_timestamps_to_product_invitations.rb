class AddingTimestampsToProductInvitations < ActiveRecord::Migration
  def change
    change_table :product_invitations do |t|
      t.timestamps
    end
  end
end
