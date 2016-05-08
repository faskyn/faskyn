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

  //on submitting changing datetime to UTC for backend
  $('[data-behavior="new-task-submit"]').on('click', function (e){
    e.preventDefault();
    var localMoment = moment($('[data-behavior="new-task-deadline"]').val());
    $('[data-behavior="new-task-deadline"]').val(localMoment.toISOString());
    $('[data-behavior="new-task-modal-form"]').submit();
  });

	//when task modal closes error messages get hidden
	$('#new-task').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

  //datetimepicker js code for new task
  $(function () {
    $('[data-behavior="new-task-deadline"]').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A',
      stepping: 15,
      widgetPositioning: { vertical: 'bottom' }
    });
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

//setting time and datetimepicker when opening edit task modal
$(document).on('shown.bs.modal', '#update-task-modal', function (e) {
  editTaskTimeSetting();
});

$(document).on('hidden.bs.modal', '#update-task-modal', function (e) {
  $('.alert-danger').hide();
});

//setting time to RoR format when updating task
$(document).on('click', '[data-behavior="edit-task-submit"]', function (e){
  e.preventDefault();
  var deadlineField = $('[data-behavior="edit-task-deadline"]');
  var localMoment = moment(deadlineField.val());
  var railsDate = localMoment.toISOString();
  deadlineField.val(railsDate);
  $('[data-behavior="task-update-form"]').submit();
});


//editing task via modal
$(document).on('click', '[data-behavior="open-edit-task-modal"]', function (event) {
  $('[data-behavior="edit-task-form-insert"]').html("<div style='text-align:center'><i class='fa fa-circle-o-notch fa-2x fa-spin' style='color:#5E5E5E'></i></div>");
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

function editTaskTimeSetting() {
  var deadlineField =  $('[data-behavior="edit-task-deadline"]');
  var deadlineValue = deadlineField.attr('value');
  var momentDeadline = moment(deadlineValue).format('MM/DD/YYYY hh:mm A');
  deadlineField.val(momentDeadline);
  deadlineField.datetimepicker({
    sideBySide: true,
    format: 'MM/DD/YYYY hh:mm A',
    stepping: 15,
    widgetPositioning: { vertical: 'bottom' }
  });
};
