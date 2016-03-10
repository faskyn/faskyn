class AddingNullConstraintToContacts < ActiveRecord::Migration
  def change
    change_column_null :contacts, :name, false
    change_column_null :contacts, :email, false
    change_column_null :contacts, :comment, false
    change_column_null :contacts, :created_at, false
    change_column_null :contacts, :updated_at, false
  end
end
