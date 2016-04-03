class RemovingRefileFromProductImageInProduction < ActiveRecord::Migration
  def change
    remove_column :products, :product_image_id, :string
    remove_column :products, :product_image_size, :integer
    remove_column :products, :product_image_filename, :string
  end
end
