class AddReportDateToDailyReports < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_reports, :report_date, :date
  end
end
