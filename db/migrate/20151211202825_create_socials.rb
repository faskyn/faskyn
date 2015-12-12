class CreateSocials < ActiveRecord::Migration
  def change
    create_table :socials do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :first_name
      t.string :last_name
      t.string :page_url
      t.string :picture_url
      t.string :location
      t.string :description
      t.string :phone

      t.timestamps null: false
    end
  end
end
