class DailyReportMailer < ApplicationMailer
  def notify_manager daily_report
    @daily_report = daily_report
    @user = daily_report.owner
    @manager = daily_report.receiver

    mail(
      to: @manager.email,
      subject: t("daily_report.mail.subject_created",
                 user_name: @user.name,
                 date: @daily_report.report_date)
    )
  end
end
