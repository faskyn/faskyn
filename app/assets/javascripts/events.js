var updateEvent;
var deleteEvent;
var currentUserId;
var createEvent;

var ready = function() {
	currentUserId = $('#bodycurrentuser').data('currentuserid');

	//autocompleting for finding existing users
	$('.event_name_company').autocomplete({
  	source: "/users/:user_id/eventnamecompanies"
	});

	//bootstrap datetimepicker for rails
	$(function () {
    $('#new-startvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A'
    });
    $('#new-endvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A'
    });
    $('#edit-startvalue').datetimepicker({
    	sideBySide: true,
    	format: 'MM/DD/YYYY hh:mm A'
    });
    $('#edit-endvalue').datetimepicker({
      sideBySide: true,
      format: 'MM/DD/YYYY hh:mm A'
    });
  });

	//when new event modal dissappears hiding the alerts
  $('#fullcalmodal-new').on('hidden.bs.modal', function (e) {
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
  	eventSources: [{ url: '/users/' + currentUserId + '/events', }],
  	eventTextColor: "#ffffff",
  	timeFormat: 'h:mm t{ - h:mm t} ', 
  	dragOpacity: "0.5",
  	//updating time with dragging and resiziing 
		eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
    	return updateEvent(event);
  	}, 
		eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
			return updateEvent(event);
    },
    //creating an event
    selectable: true,
   	selectHelper: true,
    select: function(start, end, allDay) {
    	var bootstrapStart = moment(start).format('MM/DD/YYYY hh:mm A');
    	var bootstrapEnd = moment(end).format('MM/DD/YYYY hh:mm A');
    	//var railsStart= "" + new Date(start).toUTCString();
    	$('#new-startvalue').val(bootstrapStart);
    	$('#new-endvalue').val(bootstrapEnd);
    	$('#fullcalmodal-new').modal('show');
    	//createEvent function comes here called from create.js.erb!!!!!!!!!
      $('#calendar').fullCalendar('unselect');
    },
    //showing and updating calendar event with bootstrap modal
    eventClick:  function(event, jsEvent, view) {
    	var bootstrapEditStart = moment(event.start).format('MM/DD/YYYY hh:mm A');
    	var bootstrapEditEnd = moment(event.end).format('MM/DD/YYYY hh:mm A');
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
    	if (event.body) {
    		$('#edit-bodyvalue').val(event.body);
    	};
      $('#fullcalmodal-edit').modal('show');
    	$('#event-form-update').click(function() {
				var newEvent = {
					id: event.id,
					title: event.title,
					recipientId: event.recipientId,
					senderId: event.senderId,
					senderName: event.senderName,
					recipientName: event.recipientName,
					start: new Date($('#edit-startvalue').val()),
					end: new Date($('#edit-endvalue').val()),
					allDay: ($('#edit-allday').val() == true),
					body: ($('#edit-bodyvalue').val()),
					//url: '/users/' + currentUserId + '/events/' + event.id
				};
				updateEvent(newEvent);
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
  $('#new-bodyvalue').val('');
};

//saving event updates to db
updateEvent = function(the_event) {
  $.ajax({
  	type: "PUT",
  	url: "/users/" + currentUserId + "/events/" + the_event.id,
    data: { event: {
      title: the_event.title,
      start_at: "" + new Date(the_event.start).toUTCString(),
      end_at: "" + new Date(the_event.end).toUTCString(),
      body: the_event.body || "",
      sender_id: the_event.senderId,
      recipient_id: the_event.recipientId,
      all_day: the_event.allDay }
    }
  });
};

updateView = function (the_event) {
  $('#fullcalmodal-edit').modal('hide');
  $('ul.errors').hide();
  $('.alert-danger').hide();
  $('#calendar').fullCalendar('removeEvents', the_event.id);
  $('#calendar').fullCalendar('renderEvent', newEvent, true);
}

//delete events in db
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