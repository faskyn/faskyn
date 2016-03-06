// var ready = function () {
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
});

// $(document).ready(ready);
// $(document).on("page:load", ready);

$(document).on('mouseup', '.btn-social-icon', function() {
  $(this).blur();
});
  