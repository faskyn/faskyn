class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.references :product_customer, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end
