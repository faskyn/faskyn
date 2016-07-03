class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.references :product, index: true
      t.string :name
      t.string :location
      t.date :founded
      t.integer :team_size
      t.integer :engineer_number
      t.integer :investment
      t.string :investor
      t.string :revenue_type
      t.string :revenue
      t.string :company_pitch_attachment
      t.string :company_pitch_attachment_id
      t.string :company_pitch_attachment_filename
      t.integer :company_pitch_attachment_size
      t.timestamps null: false
    end
  end
end