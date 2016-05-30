class CreateProductCustomerUsers < ActiveRecord::Migration
  def change
    create_table :product_customer_users do |t|
      t.references :user, index: true
      t.references :product_customer, index: true
    end
  end
end
