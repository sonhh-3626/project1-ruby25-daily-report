module Admin::DepartmentsHelper
  def department_action_buttons department
    content_tag(:div, class: "btn-group") do
      link_to(
        admin_department_path(department),
        class: "btn btn-sm btn-outline-primary",
        title: t("departments.index.show")
      ) do
        content_tag(:i, "", class: "fas fa-eye")
      end + link_to(
        edit_admin_department_path(department),
        class: "btn btn-sm btn-outline-warning",
        title: t("departments.index.edit")
      ) do
        content_tag(:i, "", class: "fas fa-edit")
      end + link_to(
        admin_department_path(department),
        data: {
          "turbo-method": :delete,
          "turbo-confirm": t("departments.new.confirm_delete")
        },
        class: "btn btn-sm btn-outline-danger",
        title: t("departments.index.delete")
      ) do
        content_tag(:i, "", class: "fas fa-trash-alt")
      end
    end
  end
end
