class ChangingEventAlldayType < ActiveRecord::Migration
  def self.up
    change_column :events, :all_day, 'boolean USING CAST(all_day AS boolean)'
  end
 
  def self.down
    change_column :events, :all_day, :string
  end
end
