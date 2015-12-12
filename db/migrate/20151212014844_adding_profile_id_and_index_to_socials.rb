class AddingProfileIdAndIndexToSocials < ActiveRecord::Migration
  def change
    add_column :socials, :profile_id, :integer
    add_index :socials, :profile_id
    add_index :profiles, :user_id
  end
end
