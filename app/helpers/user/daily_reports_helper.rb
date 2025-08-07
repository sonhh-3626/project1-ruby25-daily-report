module User::DailyReportsHelper
  def status_badge_class status
    case status.to_s
    when :read
      "bg-success"
    when :pending
      "bg-danger"
    else
      "bg-secondary"
    end
  end

  def daily_report_action_buttons daily_report
    content_tag(:div, class: "btn-group") do
      show_button = show_daily_report_button daily_report
      edit_button = edit_daily_report_button daily_report
      delete_button = delete_daily_report_button daily_report

      safe_join [show_button, edit_button, delete_button]
    end
  end

  private

  def show_daily_report_button daily_report
    link_to(
      user_daily_report_path(daily_report),
      class: "btn btn-sm btn-outline-primary",
      title: t("daily_report.index.show")
    ) do
      content_tag(:i, "", class: "fas fa-eye")
    end
  end

  def edit_daily_report_button daily_report
    return "" if daily_report.status_read? || daily_report.status_commented?

    link_to(
      edit_user_daily_report_path(daily_report),
      class: "btn btn-sm btn-outline-warning",
      title: t("daily_report.index.edit")
    ) do
      content_tag(:i, "", class: "fas fa-edit")
    end
  end

  def delete_daily_report_button daily_report
    return "" unless daily_report.status_pending?

    link_to(
      user_daily_report_path(daily_report),
      data: {
        "turbo-method": :delete,
        "turbo-confirm": t("daily_report.new.confirm_delete")
      },
      class: "btn btn-sm btn-outline-danger",
      title: t("daily_report.index.delete")
    ) do
      content_tag(:i, "", class: "fas fa-trash-alt")
    end
  end
end
