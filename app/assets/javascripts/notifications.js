$(document).on("page:change", function() {

  if ($('#infinite-othernotification-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-othernotification-scrolling').hide();
      var more_othernotifications_url;
      more_othernotifications_url = $('.pagination .next_page a').attr('href');
      if (more_othernotifications_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
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
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-chatnotification-scrolling').show();
        $.getScript(more_chatnotifications_url);
      }
    });
  };
});

$(document).on('click', '#other-notification-dropdown-list', function(){
  $('.other-notifications-json-data').html("<li style='text-align:center'><a href='#' style='color:#5E5E5E'><i class='fa fa-circle-o-notch fa-2x fa-spin'></i></a></li>");
  var current_user_id = $('#body-current-user').data('currentuserid');
  $.ajax({
    type: "GET",
    url: $(this).attr('href'),
    dataType: "json",
    timeout: 5000,
    success: function(data){
      var empty = "<li><a href='#'>No new notifications.</a></li>";
      var viewallURL= "/users/" + current_user_id + "/other_notifications";
      var viewall="<li role='separator' class='divider'></li><li style='text-align:center'><a style='font-weight:bold' href='" + viewallURL + "'>View all notifications</a></li>";
      var items = $.map(data, function(notification){
        return "<li><a href='" + notification.url + "'><span><img class='avatar-notification' src='" + notification.profile_image_url + "'</span><span style='padding-left:10px'>" + notification.sender_name + " " + notification.what.did + ".</span></a></li>";
      });
      if (items.length > 0) {
        $('.other-notifications-json-data').html(items);
        $('.other-notifications-json-data').append(viewall);
      }
      else {
        $('.other-notifications-json-data').html(empty);
        $('.other-notifications-json-data').append(viewall);
      }
    },
    error: function(){
      $('.other-notifications-json-data').html("<li><a href='#'>Couldn't load new notifications.</a></li>");
      $('.other-notifications-json-data').append(viewall);
    }
  });
});

$(document).on('click', '#chat-notification-dropdown-list', function(){
  $('.chat-notifications-json-data').html("<li style='text-align:center'><a href='#' style='color:#5E5E5E'><i class='fa fa-circle-o-notch fa-2x fa-spin'></i></a></li>");
  var current_user_id = $('#body-current-user').data('currentuserid');
  $.ajax({
    type: "GET",
    url: $(this).attr('href'),
    dataType: "json",
    timeout: 5000,
    success: function(data){
      var empty = "<li><a href='#'>No new chat messages.</a></li>";
      var viewallURL = "/users/" + current_user_id + "/chat_notifications";
      var viewall = "<li role='separator' class='divider'></li><li style='text-align:center'><a style='font-weight:bold' href='" + viewallURL + "'>View all notifications</a></li>";
      var items = $.map(data, function(notification){
        return "<li><a href='" + notification.url + "'><span><img class='avatar-notification' src='" + notification.profile_image_url + "'</span><span style='padding-left:10px'>" + notification.sender_name + " " + notification.what.did + ".</span></a></li>";
      });
      if (items.length > 0) {
        $('.chat-notifications-json-data').html(items);
        $('.chat-notifications-json-data').append(viewall);
      }
      else {
        $('.chat-notifications-json-data').html(empty);
        $('.chat-notifications-json-data').append(viewall);
      }
    },
    error: function(){
      $('.chat-notifications-json-data').html("<li><a href='#'>Couldn't load new notifications.</a></li>");
      $('.chat-notifications-json-data').append(viewall);
    }
  });
});
