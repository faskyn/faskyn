class AddingNullConstraintToProfiles < ActiveRecord::Migration
  def change
    change_column_null :profiles, :user_id, false
    change_column_null :profiles, :first_name, false
    change_column_null :profiles, :last_name, false
    change_column_null :profiles, :company, false
    change_column_null :profiles, :job_title, false
  end
end
