class AddingForeignKeyAndNullConstraintToProductNestedAttrs < ActiveRecord::Migration
  def up
    change_column_null :product_features, :product_id, false
    change_column_null :product_features, :feature, false
    change_column_null :product_usecases, :product_id, false
    change_column_null :product_usecases, :example, false
    change_column_null :product_usecases, :detail, false
    change_column_null :product_competitions, :product_id, false
    change_column_null :product_competitions, :competitor, false
    change_column_null :product_competitions, :differentiator, false

    add_foreign_key :product_features, :products
    add_foreign_key :product_usecases, :products
    add_foreign_key :product_competitions, :products

  end

  def down
    remove_foreign_key :product_features, :products
    remove_foreign_key :product_usecases, :products
    remove_foreign_key :product_competitions, :products

    change_column_null :product_features, :product_id, true
    change_column_null :product_features, :feature, true
    change_column_null :product_usecases, :product_id, true
    change_column_null :product_usecases, :example, true
    change_column_null :product_usecases, :detail, true
    change_column_null :product_competitions, :product_id, true
    change_column_null :product_competitions, :competitor, true
    change_column_null :product_competitions, :differentiator, true
  end
end
