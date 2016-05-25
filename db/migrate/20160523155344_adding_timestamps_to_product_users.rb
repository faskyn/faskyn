class AddingTimestampsToProductUsers < ActiveRecord::Migration
  def change
    change_table :product_users do |t|
      t.timestamps
    end
  end
end
