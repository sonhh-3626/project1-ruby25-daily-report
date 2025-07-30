class DailyReport < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :receiver, class_name: User.name

  enum status: Settings.daily_report_status.to_h
end
