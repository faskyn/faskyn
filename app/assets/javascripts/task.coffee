ready = ->
	$('.task_name_company').autocomplete
		source: "/users/:user_id/tasknamecompanies"

$(document).ready(ready)
$(document).on("page:load", ready)
