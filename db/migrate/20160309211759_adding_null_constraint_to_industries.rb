class AddingNullConstraintToIndustries < ActiveRecord::Migration
  def change
    change_column_null :industries, :name, false
  end
end
