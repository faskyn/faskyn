class ChangingEventBodyToDescription < ActiveRecord::Migration
  def change
    rename_column :events, :body, :description
  end
end
