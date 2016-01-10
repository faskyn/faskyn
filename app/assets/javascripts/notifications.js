var ready = function() {  

  if ($('#infinite-othernotification-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-othernotification-scrolling').hide();
      var more_othernotifications_url;
      more_othernotifications_url = $('.pagination .next_page a').attr('href');
      if (more_othernotifications_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-othernotification-scrolling').show();
        $.getScript(more_othernotifications_url);
      }
    });
  };

  if ($('#infinite-chatnotification-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-chatnotification-scrolling').hide();
      var more_chatnotifications_url;
      more_chatnotifications_url = $('.pagination .next_page a').attr('href');
      if (more_chatnotifications_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-chatnotification-scrolling').show();
        $.getScript(more_chatnotifications_url);
      }
    });
  };
};

$(document).ready(ready);
$(document).on("page:load", ready);