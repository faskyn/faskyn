class AddingNullConstraintToTasks < ActiveRecord::Migration
  def change
    change_column_null :tasks, :assigner_id, false
    change_column_null :tasks, :executor_id, false
    change_column_null :tasks, :content, false
    change_column_null :tasks, :deadline, false
  end
end