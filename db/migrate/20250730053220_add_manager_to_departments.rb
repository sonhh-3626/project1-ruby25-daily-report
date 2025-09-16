class AddManagerToDepartments < ActiveRecord::Migration[7.0]
  def change
    add_reference :departments, :manager, foreign_key: { to_table: :users }, index: true
  end
end
