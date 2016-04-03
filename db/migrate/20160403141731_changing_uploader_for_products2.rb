class ChangingUploaderForProducts2 < ActiveRecord::Migration
  def change
    add_column :products, :product_image, :string
  end
end
