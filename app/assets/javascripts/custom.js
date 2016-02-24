$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();

  //flash messages fade out after 3.5 sec
  setTimeout(function(){
		$('.alert').fadeOut(2500, function(){
			$('.flash-container').remove();
		})
	}, 3500);
});


//making whole tr linkable
$(document).on('click', 'tr[data-link]', function() {
	window.location = $(this).data('link');
});

