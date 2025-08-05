module Manager::UsersHelper
  def user_action_buttons user
    content_tag(:div, class: "btn-group") do
      link_to(
        manager_user_path(user),
        class: "btn btn-sm btn-outline-primary",
        title: t("users.index.show")
      ) do
        content_tag(:i, "", class: "fas fa-eye")
      end + link_to(
        manager_user_path(user),
        data: {
          "turbo-method": :delete,
          "turbo-confirm": t("users.new.confirm_delete")
        },
        class: "btn btn-sm btn-outline-danger",
        title: t("users.index.delete")
      ) do
        content_tag(:i, "", class: "fas fa-trash-alt")
      end
    end
  end
end
