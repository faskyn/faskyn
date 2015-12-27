var updateEvent;
var deleteEvent;
var currentUserId;
var createEvent;

var ready = function() {
  //getting current user from body tag
	currentUserId = $('#bodycurrentuser').data('currentuserid');

	//autocompleting for finding existing users
	$('.event_name_company').autocomplete({
  	source: "/users/:user_id/eventnamecompanies"
	});

	//bootstrap datetimepicker for rails
	$(function () {
    $('#new-startvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A',
      stepping: 15
    });
    $('#new-endvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A',
      stepping: 15
    });
    $('#edit-startvalue').datetimepicker({
    	sideBySide: true,
    	format: 'MM/DD/YYYY hh:mm A',
      stepping: 15
    });
    $('#edit-endvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A',
      stepping: 15
    });
  });

	//when new and edit event modal dissappears hiding the previous alerts
  $('#fullcalmodal-new').on('hidden.bs.modal', function (e) {
		$('.alert-danger').hide();
	});

  $('#fullcalmodal-edit').on('hidden.bs.modal', function (e) {
    $('.alert-danger').hide();
  });

	//fullcalendar default settings
  $('#calendar').fullCalendar({
    editable: true,
    allDayDefault: false,
    header: {
      left: 'prev,next today', 
      center: 'title', 
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek', 
    height: 500, 
    slotMinutes: 30,
    eventSources: [{  url: '/users/' + currentUserId + '/events' }],
    eventTextColor: "#ffffff",
    eventBorderColor: "#007cc3",
    eventBackgroundColor: "#007cc3",
    timeFormat: 'hh:mm A', 
    dragOpacity: "0.5",
    //what to show in events
    eventRender: function (event, element, view) {
      if (event.senderId && event.recipientId) {
        if (event.senderId === currentUserId) {
          element.find('.fc-title').append('<div class="hr-line-solid-no-margin"></div><span style="font-size: 12px">'+event.recipientName+'</span></div>');
        }
        else {
          element.find('.fc-title').append('<div class="hr-line-solid-no-margin"></div><span style="font-size: 12px">'+event.senderName+'</span></div>');
        };
      };
      if (event.description) {
        element.find('.fc-title').append('<div class="hr-line-solid-no-margin"></div><span style="font-size: 10px">'+event.description+'</span></div>');
      };
    },
    //setting color of incoming events
    eventAfterRender: function (event, element, view) {
      if (event.recipientId && event.recipientId === currentUserId) {
        element.css('background-color', '#d9edf7');
        element.css('border-color', '#bce8f1');
        element.css('color', '#31708f');
      };
    },
  	//updating time with dragging and resiziing 
		eventDrop: function(event, delta, revertFunc, jsEvent, ui, view) {
    	updateEvent(event, revertFunc);
      return false;
  	}, 
		eventResize: function(event, delta, revertFunc, jsEvent, ui, view) {
			updateEvent(event, revertFunc);
      return false;
    },
    //creating an event
    selectable: true,
   	selectHelper: true,
    select: function(start, end, jsEvent, view) {
    	var bootstrapStart = moment(start).format('MM/DD/YYYY hh:mm A');
    	var bootstrapEnd = moment(end).format('MM/DD/YYYY hh:mm A');
    	//var railsStart= "" + new Date(start).toUTCString();
    	$('#new-startvalue').val(bootstrapStart);
    	$('#new-endvalue').val(bootstrapEnd);
    	$('#fullcalmodal-new').modal('show');
    	//createEvent function comes here called from create.js.erb!!!!!!!!!
      $('#calendar').fullCalendar('unselect');
    },
    //showing and updating or deleting calendar event with bootstrap modal
    eventClick:  function(event, jsEvent, view) {
      //setting the modal values via js
    	var bootstrapEditStart = moment(event.start).format('MM/DD/YYYY hh:mm A');
    	var bootstrapEditEnd = moment(event.end).format('MM/DD/YYYY hh:mm A');
      $('#edit-modalid').val(event.id);
      $('#edit-modaltitle').html(event.title);
      $('#edit-startvalue').val(bootstrapEditStart);
      if (event.end) {
      	$('#edit-endvalue').val(bootstrapEditEnd);
    	};
    	if (event.recipientId == currentUserId) {
    		$('#edit-uservalue').text("Sender: " + event.senderName);
    	}
    	else {
    		$('#edit-uservalue').text("Recipient: " + event.recipientName);
    	};
    	if (event.description) {
    		$('#edit-descriptionvalue').val(event.description);
    	};
      if (event.allDay == true) {
        $('#edit-alldayvalue').prop('checked', true);
      };
      $('#fullcalmodal-edit').modal('show');
    	$('#event-form-update').click(function() {
        //saving to var the changes of the form
        var checkbox;
        if ($('#edit-alldayvalue').prop("checked")) {
          checkbox = true;
        }
        else { 
          checkbox = false; 
        };
				var newEvent = {
					id: event.id,
					title: event.title,
					recipientId: event.recipientId,
					senderId: event.senderId,
					senderName: event.senderName,
					recipientName: event.recipientName,
					start: new Date($('#edit-startvalue').val()),
					end: new Date($('#edit-endvalue').val()),
					allDay: checkbox,
					description: ($('#edit-descriptionvalue').val()),
				};
				updateEvent2(newEvent);
			});
			$('#event-form-delete').click(function() {
	 			$('#fullcalmodal-edit').modal('hide');
				$('#calendar').fullCalendar('removeEvents', event.id);
				deleteEvent(event);
			});
			return false;
    }
  });
};

createEvent =  function() {
	//rendering new event
	$('#calendar').fullCalendar('removeEvents');
	$('#calendar').fullCalendar('addEventSource', "/users/" + currentUserId + "/events");
	$('#calendar').fullCalendar('rerenderEvents');
	//emptying modal
	$('#fullcalmodal-new').modal('hide');
	$('#new-titlevalue').val('');
  $('#new-alldayvalue').val(false);
  $('#new-recipientvalue').val('');
  $('#new-descriptionvalue').val('');
};

//update for drag + resize
updateEvent = function(the_event, the_revertFunc) {
  $.ajax({
    type: "PUT",
    url: "/users/" + currentUserId + "/events/" + the_event.id,
    data: { event: {
      title: the_event.title,
      start_at: "" + new Date(the_event.start).toUTCString(),
      end_at: "" + new Date(the_event.end).toUTCString(),
      description: the_event.description || "",
      sender_id: the_event.senderId,
      recipient_id: the_event.recipientId,
      all_day: the_event.allDay }
    },
    success: function() {
      alert('Event updated!');
    },
    error: function(xhr) {
      var errors = xhr.responseJSON.errormessages;
      for (message in errors) {
        alert(errors[message]);
      };
      the_revertFunc();
    }
  });
};    

//update for click (modal form)
updateEvent2 = function(the_event) {
  $.ajax({
  	type: "PUT",
  	url: "/users/" + currentUserId + "/events/" + the_event.id,
    data: { event: {
      title: the_event.title,
      start_at: "" + new Date(the_event.start).toUTCString(),
      end_at: "" + new Date(the_event.end).toUTCString(),
      description: the_event.description || "",
      sender_id: the_event.senderId,
      recipient_id: the_event.recipientId,
      all_day: the_event.allDay }
    },
    success: function() {
      $('#fullcalmodal-edit').modal('hide');
      $("ul.errors").html("");
      $('ul.errors').hide();
      $('.alert-danger').hide();
      $('#calendar').fullCalendar('removeEvents', the_event.id);
      $('#calendar').fullCalendar('renderEvent', the_event, true);
      alert('Event updated!');
    },
    error: function(xhr) {
      var errors = xhr.responseJSON.errormessages;
      $("ul.errors").html("");
      $('.alert-danger').show();
      $('ul.errors').show();
      for (message in errors) {
        $("ul.errors").append("<li>" + errors[message] + "</li>");
      };
    }
  });
};

//deleting events after clicking on them
deleteEvent = function(the_event) {
  $.ajax({
  	type: "POST",
  	url: "/users/" + currentUserId + "/events/" + the_event.id,
  	dataType: "json",
    data: {"_method":"delete"}
  });
};

$(document).ready(ready);
$(document).on("page:load", ready);