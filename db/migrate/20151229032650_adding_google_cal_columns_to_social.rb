class AddingGoogleCalColumnsToSocial < ActiveRecord::Migration
  def change
    add_column :socials, :email, :string
    add_column :socials, :refresh_token, :string
    add_column :socials, :expires_at, :datetime
  end
end
