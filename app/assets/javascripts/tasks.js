$(document).on("page:change", function() {

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

  $('.new-html-task-submit').on('click', function (e) {
    e.preventDefault();
    var localMoment = moment($('.new-task-deadline').val());
    $('.new-task-deadline').val(localMoment.toISOString());
    $('.new-html-task-form').submit();
  });

	//when task modal closes error messages get hidden
	$('#newtask').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

  //datetimepicker js code for new task
  $(function () {
    $('.new-task-deadline').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A',
      stepping: 15,
      widgetPositioning: { vertical: 'bottom' }
    });
  });

  //setting time and datetimepicker when opening edit task modal
  var task_edit_page = $('.edit-task-well');
  if (task_edit_page.length > 0) {
    edit_task_html_form();
  };

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
$(document).on('shown.bs.modal', '.updatetask', function (e) {
  var taskId = $(this).find('.edit-task-submit').data('taskid');
  var deadlineField =  $(".task_form_" + taskId).closest('.updatetask').find($('.edit-task-deadline'));
  var deadlineValue = deadlineField.attr('value');
  var momentDeadline = moment(deadlineValue).format('MM/DD/YYYY hh:mm A');
  deadlineField.val(momentDeadline);
  $(".task_form_" + taskId).closest('.updatetask').find($('.edit-task-deadline')).datetimepicker({
    sideBySide: true,
    format: 'MM/DD/YYYY hh:mm A',
    stepping: 15,
    widgetPositioning: { vertical: 'bottom' }
  });
});

$(document).on('hidden.bs.modal', '.updatetask', function (e) {
  $('.alert-danger').hide();
});

//setting time to RoR format when updating task
$(document).on('click', '.edit-task-submit', function (e){
  e.preventDefault();
  var taskId = $(this).data('taskid');
  var deadlineField = $(".task_form_" + taskId).closest('.updatetask').find($('.edit-task-deadline'));
  var localMoment = moment(deadlineField.val());
  var railsDate = localMoment.toISOString();
  deadlineField.val(railsDate);
  $(".task_form_" + taskId).submit();
});

$(document).on('click', '.edit-task-submit-html', function (e) {
  e.preventDefault;
  var localMoment = moment($('.task-deadline').val());
  var railsDate = localMoment.toISOString();
  $('.task-deadline').val(railsDate);
  $('.task-deadline').closest('form').submit();
});

function edit_task_html_form() {
  var deadlineValue = $('.task-deadline').attr('value');
  var momentDeadline = moment(deadlineValue).format('MM/DD/YYYY hh:mm A');
  $('.task-deadline').val(momentDeadline);
  $('.task-deadline').datetimepicker({
    sideBySide: true,
    format: 'MM/DD/YYYY hh:mm A',
    stepping: 15,
    widgetPositioning: { vertical: 'bottom' }
  });
};
