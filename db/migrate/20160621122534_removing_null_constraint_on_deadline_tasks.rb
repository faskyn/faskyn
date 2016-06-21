class RemovingNullConstraintOnDeadlineTasks < ActiveRecord::Migration
  def up
    change_column_null :tasks, :deadline, true
  end

  def down
    change_column_null :tasks, :deadline, false 
  end
end
