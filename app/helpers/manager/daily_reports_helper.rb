module Manager::DailyReportsHelper
  def manager_daily_report_action_buttons daily_report
    content_tag(:div, class: "btn-group") do
      link_to(
        edit_manager_daily_report_path(daily_report),
        class: "btn btn-sm btn-outline-primary",
        title: t("daily_reports.index.show")
      ) do
        content_tag(:i, "", class: "fas fa-eye")
      end
    end
  end

  def daily_report_edit_link(report)
    url = Rails.application.routes.url_helpers.edit_manager_daily_report_url(
      report,
      host: mailer_host,
      port: mailer_port,
      locale: I18n.locale
    )

    link_to t("daily_report.mail.view_button"), url
  end

  private

  def mailer_host
    ENV["MAILER_HOST"] || Rails.application.config.action_mailer
                               .default_url_options[:host] || "localhost"
  end

  def mailer_port
    ENV["MAILER_PORT"] || 3000
  end
end
