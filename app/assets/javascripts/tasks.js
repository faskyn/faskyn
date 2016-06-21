$(document).on("page:change", function() {

	//choosing user on task creation; needed only for new task
	$('[data-behavior="new-task-executor"]').autocomplete({
  	source: "/users/:user_id/tasknamecompanies"
	});

	//unfocus the new task button after modal open
	$('#new-task').on('shown.bs.modal', function (e) {
    $('.newbutton').one('focus', function (e) {
    	$(this).blur();
		});
	});

	//when task modal closes error messages get hidden
	$('#new-task').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

	//infinite scrolling for tasks based on pagination gem
	if ($('#infinite-task-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-task-scrolling').hide();
      var more_tasks_url;
      more_tasks_url = $('#infinite-task-scrolling .pagination .next_page a').attr('href');
      if (more_tasks_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("<i class='fa fa-circle-o-notch fa-2x fa-spin'></i>");
        $('#infinite-task-scrolling').show();
        $.getScript(more_tasks_url);
      }
    });
  };
});

$(document).on('hidden.bs.modal', '#update-task-modal', function (e) {
  $('.alert-danger').hide();
});

//editing task via modal
$(document).on('click', '[data-behavior="open-edit-task-modal"]', function (event) {
  $('[data-behavior="edit-task-form-insert"]').html("<div style='text-align:center;padding-top:15px;padding-bottom:15px;'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
  var href = $(this).data("task-edit-link");
  $.ajax({
    type: "GET",
    url: href,
    dataType: "script"
  });
});

//deleting task via modal
$(document).on('click', '[data-behavior="open-delete-task-modal"]', function (event) {
  var taskDeleteLink = $(this).data("task-delete-link");
  $('[data-behavior="delete-task-submit"]').data("task-destroy-link", taskDeleteLink);
});

$(document).on('click', '[data-behavior="delete-task-submit"]', function (event) {
  var href = $(this).data("task-destroy-link");
  $.ajax({
    type: "DELETE",
    url: href,
    dataType: "script"
  });
});