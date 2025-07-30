class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :daily_reports, :status
    add_index :daily_reports, :created_at
  end
end
