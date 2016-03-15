class AddingFailedAttemptsToDevise < ActiveRecord::Migration
  def up
    add_column :users, :failed_attempts, :integer, default: 0, null: false
  end

  def down
    remove_column :users, :failed_attempts
  end
end
