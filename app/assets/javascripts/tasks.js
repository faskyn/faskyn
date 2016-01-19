$(document).on("page:change", function() {

  //these functions get called in js.erb files AS WELL to make js work on AJAX appended task partials
  //here are invoked to work on document ready tasks
  edit_task_time_for_user($(document.body));
  edit_task_datetimepicker($(document.body));
  edit_task_time_on_submit($(document.body));
  edit_task_hide_danger($(document.body));

	//choosing user on task creation; needed only for new task
	$('.task_name_company').autocomplete({
  	source: "/users/:user_id/tasknamecompanies"
	});

	//unfocus the newtask button after modal open
	$('#newtask').on('shown.bs.modal', function (e) {
    $('.newbutton').one('focus', function (e) {
    	$(this).blur();
		});
	});

  //on submitting changing datetime to UTC for backend
  $('.new-task-submit').on('click', function (e){
    e.preventDefault();
    var localMoment = moment($('.new-task-deadline').val());
    $('.new-task-deadline').val(localMoment.toISOString());
    $('#newtask').submit();
  });

	//when task modal closes error messages get hidden
	$('#newtask').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

  // $('.updatetask').on('hidden.bs.modal', function (e) {
  //   $('.alert-danger').hide();
  // });

  //datetimepicker js code for new task
  $(function () {
    $('.new-task-deadline').datetimepicker({
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
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-task-scrolling').show();
        $.getScript(more_tasks_url);
      }
    });
  };
});

//changes edit task modal deadline datetime to be in localtime when modal pops up
function edit_task_time_for_user($container) {
  $container.find('.updatetask').on('shown.bs.modal', function (e) {
    var deadlineField = $(this).find($('.edit-task-deadline'));
    var deadlineValue = deadlineField.attr('value');
    var momentDeadline = moment(deadlineValue).format('MM/DD/YYYY hh:mm A');
    deadlineField.val(momentDeadline);
  });
}

function edit_task_hide_danger($container) {
  $container.find('.updatetask').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });
}

//makes datetimepicker available for editing task modal
function edit_task_datetimepicker($container) {
  $container.find('.edit-task-deadline').datetimepicker({
    sideBySide: true,
    format: 'MM/DD/YYYY hh:mm A',
    stepping: 15,
    widgetPositioning: { vertical: 'bottom' }
  });
}

//changes edit task modal deadline datetime to ruby format in UTC
function edit_task_time_on_submit($container) {
  $container.find('.edit-task-submit').on('click', function (e){
    e.preventDefault();
    var deadlineField = $(this).closest('form').find($('.edit-task-deadline'));
    var localMoment = moment(deadlineField.val());
    deadlineField.val(localMoment.toISOString());
    $(this).submit();
  });
}

// $(document).ready(ready);
// $(document).on("page:load", ready);