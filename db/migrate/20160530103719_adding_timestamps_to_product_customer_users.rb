class AddingTimestampsToProductCustomerUsers < ActiveRecord::Migration
  def change
    change_table :product_customer_users do |t|
      t.timestamps null: false
    end
  end
end
