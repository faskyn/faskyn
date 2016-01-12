// var ready = function () {
$(document).on("page:change", function() {

  //infinite scrolling on user index page
  if ($('#infinite-user-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-user-scrolling').hide();
      var more_users_url;
      more_users_url = $('.pagination .next_page a').attr('href');
      if (more_users_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-user-scrolling').show();
        $.getScript(more_users_url);
      }
    });
  };

  // $(".btn-social-icon").mouseup(function(){
  //   $(this).blur();
  // });
});

// $(document).ready(ready);
// $(document).on("page:load", ready);

$(document).on('mouseup', '.btn-social-icon', function() {
  $(this).blur();
});
  