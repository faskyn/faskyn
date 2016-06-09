class AddingNicknameToSocials < ActiveRecord::Migration
  def up
    add_column :socials, :nickname, :string
  end

  def down
    remove_column :socials, :nickname, :string
  end
end
