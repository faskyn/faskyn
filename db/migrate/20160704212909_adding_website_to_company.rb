class AddingWebsiteToCompany < ActiveRecord::Migration
  def up
    add_column :companies, :website, :string
  end

  def down
    remove_column :companies, :website, :string
  end
end
