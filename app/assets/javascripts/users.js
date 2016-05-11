$(document).on("page:change", function() {

  //infinite scrolling on user index page
  if ($('#infinite-user-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-user-scrolling').hide();
      var more_users_url;
      more_users_url = $('.pagination .next_page a').attr('href');
      if (more_users_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-user-scrolling').show();
        $.getScript(more_users_url);
      }
    });
  };

  //in case of current user's profile edit button gets visible (important for caching)
  if ($('.profile-container').length > 0) {
    if ($('.profile-container').data('profileuserid') == $('#body-current-user').data('currentuserid')) {
      $('[data-behavior="edit-profile-button"]').removeClass('hidden');
    };
  };
});

$(document).on('mouseup', '[data-behavior="btn-social-icon"]', function() {
  $(this).blur();
});
  