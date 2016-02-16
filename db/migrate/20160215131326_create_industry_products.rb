class CreateIndustryProducts < ActiveRecord::Migration
  def change
    create_table :industry_products do |t|
      t.references :product, index: true
      t.references :industry, index: true
    end
  end
end
