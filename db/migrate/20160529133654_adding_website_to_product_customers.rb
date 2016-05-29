class AddingWebsiteToProductCustomers < ActiveRecord::Migration
  def up
    add_column :product_customers, :website, :string
  end

  def down
    remove_column :product_customers, :website, :string
  end
end
