class CreateIndustryUsersTable < ActiveRecord::Migration
  def change
    create_table :industry_users_tables do |t|
      t.references :user, index: true
      t.references :industry, index: true
    end
  end
end
