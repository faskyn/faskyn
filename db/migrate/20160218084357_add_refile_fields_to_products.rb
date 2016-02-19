class AddRefileFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_image_filename, :string
    add_column :products, :product_image_size, :integer
  end
end
