class AddingImageToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :post_image, :string
  end

  def down
    remove_column :posts, :post_image, :string
  end
end
