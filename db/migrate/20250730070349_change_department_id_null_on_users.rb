class ChangeDepartmentIdNullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :department_id, true
  end
end
