$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();

  var alert = $('.alert.flash-alert');
  if (alert.length > 0) {
    if ($('#body-current-user').data('currentuserid')) {
      alert.show().animate({height: alert.outerHeight()}, 200);
      window.setTimeout(function() {
        alert.slideUp();
      }, 4500);
    }
    else {
      alert.show().animate({height: alert.outerHeight()}, 200);
      window.setTimeout(function() {
        alert.slideUp();
      }, 10000);
    }
  }
});

//making flash hidden if user clicks anywhere
$(document).on('click', window, function() {
  var alert = $('.alert.flash-alert');
  alert.hide();
});


//making whole tr linkable
$(document).on('click', 'tr[data-link]', function() {
	window.location = $(this).data('link');
});

$(document).on('click', '[data-behavior="twitter-share"]',function() {
  twitter = $(this);
  twitterWindow = 'http://twitter.com/share?text='
    + twitter.data('twittertext') + '&url='
    + twitter.data('twitterurl')
    + twitter.data('twitteranchor');
  window.open(twitterWindow, '_blank', 'width=800, height=500, top=200, left=300');
});

