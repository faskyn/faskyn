class AddAlldayToCalendar < ActiveRecord::Migration
  def change
    add_column :events, :all_day, :string
  end
end
