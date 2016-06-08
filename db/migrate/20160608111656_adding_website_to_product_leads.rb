class AddingWebsiteToProductLeads < ActiveRecord::Migration
  def up
    add_column :product_leads, :website, :string
  end

  def down
    remove_column :product_leads, :website, :string
  end
end
