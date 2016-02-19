class RenameColumnInProductUsecases < ActiveRecord::Migration
  def change
    rename_column :product_usecases, :details, :detail
  end
end
