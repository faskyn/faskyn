class CreateProductUsers < ActiveRecord::Migration
  def change
    create_table :product_users do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.string :role, index: true
    end
  end
end
