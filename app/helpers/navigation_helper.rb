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
        label: t("nav_items.help"),
        path: help_path,
        icon: "handshake-angle",
        roles: %w(admin manager user)
      }
    ]

    all_items.select{|item| item[:roles].include?(role.to_s)}
  end
end
