class RenameColumnInProductCompetitors < ActiveRecord::Migration
  def change
    rename_column :product_competitions, :diferentatior, :differentiator
  end
end
