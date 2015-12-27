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

	//when task modal closes error messages get hidden
	$('#newtask').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

  $('.updatetask').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });


  $(function () {
    $('.datetimepicker').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A'
    });
  });

	//infinite scrolling for tasks
	if ($('#infinite-task-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      $('#infinite-task-scrolling').hide();
      var more_tasks_url;
      more_tasks_url = $('.pagination .next_page a').attr('href');
      if (more_tasks_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        $('#infinite-task-scrolling').show();
        $.getScript(more_tasks_url);
      }
    });
  };

};

$(document).ready(ready);
$(document).on("page:load", ready);