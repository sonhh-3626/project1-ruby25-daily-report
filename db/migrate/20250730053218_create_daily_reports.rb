class CreateDailyReports < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_reports do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }, type: :bigint
      t.references :receiver, foreign_key: { to_table: :users }, type: :bigint
      t.integer :status, default: 0
      t.datetime :reviewed_at
      t.text :planned_tasks
      t.text :actual_tasks
      t.text :incomplete_reason
      t.text :next_day_planned_tasks
      t.text :manager_notes

      t.timestamps
    end
  end
end
