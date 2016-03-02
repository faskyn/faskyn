$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();

  //flash messages fade out after 3.5 sec
 //  setTimeout(function(){
	// 	$('.alert').fadeOut(2500, function(){
	// 		$('.flash-container').remove();
	// 	})
	// }, 3500);

var alert = $('.alert.flash-alert');
  if (alert.length > 0) {
    alert.show().animate({height: alert.outerHeight()}, 200);
    window.setTimeout(function() {
      alert.slideUp();
    }, 3000);
  }
});


//making whole tr linkable
$(document).on('click', 'tr[data-link]', function() {
	window.location = $(this).data('link');
});

