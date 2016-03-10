class AddingNullConstraintToIndustryProducts < ActiveRecord::Migration
  def change
    change_column_null :industry_products, :product_id, false
    change_column_null :industry_products, :industry_id, false
  end
end
