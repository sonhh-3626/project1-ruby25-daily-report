$(document).on('turbo:load', function () {
  const $currentLanguage = $('#current-language');
  const $languageDropdown = $('#language-dropdown');

  $currentLanguage.on('click', function () {
    $languageDropdown.toggle();
  });

  $(document).on('click', function (e) {
    if (
      !$currentLanguage.is(e.target) &&
      $currentLanguage.has(e.target).length === 0 &&
      !$languageDropdown.is(e.target) &&
      $languageDropdown.has(e.target).length === 0
    ) {
      $languageDropdown.hide();
    }
  });
});
