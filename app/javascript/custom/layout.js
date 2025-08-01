let isCollapsed = false;

function setupSidebar() {
  const $toggleButton = $('#toggle-icon');
  const $sidebar = $('.sidebar');
  const $mainArea = $('.main-area');

  if ($toggleButton.length === 0 || $sidebar.length === 0 || $mainArea.length === 0) return;

  let isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';

  const applySidebarState = () => {
    $sidebar.toggleClass('collapsed', isCollapsed);
    $mainArea.toggleClass('expanded', isCollapsed);
    $toggleButton.attr('class', isCollapsed ? 'fas fa-bars menu-toggle' : 'fas fa-times menu-toggle');
  };

  applySidebarState();

  $toggleButton.on('click', function () {
    isCollapsed = !isCollapsed;
    localStorage.setItem('sidebarCollapsed', isCollapsed);
    applySidebarState();
  });
}

function setupNavItems() {
  const $navItems = $('.nav-item');

  $navItems.on('click', function () {
    $navItems.removeClass('active');
    $(this).addClass('active');

    const url = $(this).data('url');
    if (url) {
      window.location.href = url;
    }
  });

  const currentPath = window.location.pathname;

  $navItems.each(function () {
    if ($(this).data('url') === currentPath) {
      $(this).addClass('active');
    }
  });
}

$(document).on('turbo:load', function () {
  setupSidebar();
  setupNavItems();
});
