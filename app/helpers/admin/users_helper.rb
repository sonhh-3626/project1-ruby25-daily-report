module Admin::UsersHelper
  def admin_user_action_buttons user
    content_tag(:div, class: "btn-group") do
      link_to(
        admin_user_path(user),
        class: "btn btn-sm btn-outline-primary",
        title: t("users.index.show")
      ) do
        content_tag(:i, "", class: "fas fa-eye")
      end + link_to(
        edit_admin_user_path(user),
        class: "btn btn-sm btn-outline-warning",
        title: t("users.index.edit")
      ) do
        content_tag(:i, "", class: "fas fa-edit")
      end +
        if user.active?
          link_to(
            admin_user_path(user),
            class: "btn btn-sm btn-outline-danger",
            data: {
              "turbo-method": :delete,
              "turbo-confirm": t("users.new.confirm_delete")
            }
          ) do
            content_tag(:i, "", class: "fas fa-toggle-on")
          end
        end
    end
  end

  def active_options_for_select
    [
      [t("users.active"), true],
      [t("users.inactive"), false]
    ]
  end
end
