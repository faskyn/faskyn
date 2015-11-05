var ready = function() {

	//choosing user on task creation
	$('.task_name_company').autocomplete({
  	source: "/users/:user_id/tasknamecompanies"
	});

	//unfocus the newtask button after modal closing
	$('#newtask').on('shown.bs.modal', function (e) {
    $('.newbutton').one('focus', function (e) {
    	$(this).blur();
		});
	});

	//when modal closes error messages get hidden
	$('#newtask').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

};

$(document).ready(ready);
$(document).on("page:load", ready);
