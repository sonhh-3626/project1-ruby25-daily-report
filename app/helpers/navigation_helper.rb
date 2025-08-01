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
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> ef531e2 ([Admin] Quản lý bộ phận (CRUD))
        label: t("nav_items.departments"),
        path: admin_departments_path,
        icon: "home",
        roles: %w(admin)
      },
      {
<<<<<<< HEAD
        label: t("nav_items.users"),
        path: users_path,
        icon: "users",
        roles: %w(admin)
      },
      {
>>>>>>> 7832176 ([Admin] Thêm/Xóa manager cho 1 bộ phận)
=======
>>>>>>> ef531e2 ([Admin] Quản lý bộ phận (CRUD))
        label: t("nav_items.help"),
        path: help_path,
        icon: "handshake-angle",
        roles: %w(admin manager user)
      }
    ]

    all_items.select{|item| item[:roles].include?(role.to_s)}
  end
end
