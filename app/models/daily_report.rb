class DailyReport < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :receiver, class_name: User.name

  enum status: Settings.daily_report_status.to_h, _prefix: true
  DAILY_REPORT_PARAMS = %w(receiver_id owner_id report_date
                           planned_tasks actual_tasks
                           incomplete_reason
                           next_day_planned_tasks).freeze

  validates :planned_tasks, :actual_tasks, :next_day_planned_tasks,
            length: {minimum: Settings.MIN_LENGTH_TEXT_20}

  validates :report_date, presence: true
  validate :unique_report_per_day

  scope :order_created_at_desc, ->{order(created_at: :desc)}
  scope :by_status, lambda{|status|
    where(status:) if status.present? && statuses.key?(status)
  }
  scope :by_report_date, lambda{|date|
    where(report_date: date) if date.present?
  }

  private

  def unique_report_per_day
    return if report_date.blank? || owner_id.blank?

    existing = DailyReport.where(owner_id:, report_date:)
                          .where.not(id:)

    return unless existing.exists?

    errors.add(
      :report_date,
      :taken,
      message: I18n.t("daily_report.create.error_report_date")
    )
  end
end
