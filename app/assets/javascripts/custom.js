$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();

  setTimeout(function(){
		$('.flash-container').fadeOut(1000, function(){
			$(this).remove();
		})
	}, 3500);
});