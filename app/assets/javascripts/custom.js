$(document).ready(function(){
	setTimeout(function(){
		$('.flash-container').fadeOut(1000, function(){
			$(this).remove();
		})
	}, 3500);
});

$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip()
})