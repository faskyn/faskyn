class RemoveUsecaseFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :usecase
  end
end
