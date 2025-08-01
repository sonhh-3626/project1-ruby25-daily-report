class AddUniqueIndexToDepartmentsName < ActiveRecord::Migration[7.0]
  def change
    add_index :departments, :name, unique: true
  end
end
