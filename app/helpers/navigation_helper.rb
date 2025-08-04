module NavigationHelper
  def nav_items_for role
    all_items = [
      {
        label: t("nav_items.dashboard"),
        path: root_path,
        icon: "tachometer-alt",
        roles: %w(admin manager user)
      },
      {
        label: t("nav_items.departments"),
        path: admin_departments_path,
        icon: "home",
        roles: %w(admin)
      },
      {
        label: t("nav_items.users"),
        path: users_path,
        icon: "users",
        roles: %w(admin)
      },
      {
        label: t("nav_items.help"),
        path: help_path,
        icon: "handshake-angle",
        roles: %w(admin manager user)
      },
      {
        label: t("nav_items.logout"),
        path: nil,
        icon: "sign-out",
        roles: %w(admin manager user)
      }
    ]

    all_items.select{|item| item[:roles].include?(role.to_s)}
  end
end
