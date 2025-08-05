module Manager::DepartmentsHelper
  def department_action_buttons department
    content_tag(:div, class: "btn-group") do
      link_to(
        manager_department_path(department),
        class: "btn btn-sm btn-outline-primary",
        title: t("departments.index.show")
      ) do
        content_tag(:i, "", class: "fas fa-eye")
      end
    end
  end
end
