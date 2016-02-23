$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();

  setTimeout(function(){
		$('.alert').fadeOut(2500, function(){
			$('.flash-container').remove();
		})
	}, 3500);
});