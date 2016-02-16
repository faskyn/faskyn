class DropIndustryUserTable < ActiveRecord::Migration
  def change
    drop_table :industry_users_tables
  end
end
