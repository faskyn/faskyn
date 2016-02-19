class RemoveCompetitorFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :competition
  end
end
