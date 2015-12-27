var updateEvent;
var currentUserId;
var ready = function() {
	currentUserId = $('#bodycurrentuser').data('currentuserid');
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
    	$('#new-startvalue').text(start);
    	$('#new-endvalue').text(end);
    	if (allDay == false) {
    		$('#new-alldayvalue').val(1);
    	}
    	else {
    		$('#new-alldayvalue').val(0);
    	};
    	$('#fullcallmodal-new').modal('show');
    	$('#event-form-create').click(function() {
    	//having bootstrap model here to put recipientId, title and body
	    	if ($('#new-titlevalue').val() != "") {
	    		$('#fullcallmodal-new').modal('hide');
		    	$('#calendar').fullCalendar('renderEvent',
		        {
		          start: start,
		          end: end,
		          allDay: $('#new-alldayvalue').val(),
		          title: $('#new-titlevalue').val(),
		          senderId: currentUserId,
		          recipientId: $('#new-recipientvalue').val(),
		          body: $('#new-bodyvalue').val()
		        },
		        true //making event stick
		      );
	      };
		   //    //making new event persist
		   //    $.ajax({
		   //    	type: "POST",
		   //    	url: "/users/" + currentUserId + "/events",
		   //    	data: { event: {
				 //      title: $('#new-titlevalue').val(),
				 //      start_at: "" + new Date(start).toUTCString(),
				 //      end_at: "" + new Date(end).toUTCString(),
				 //      body: $('#new-bodyvalue').val() || "",
				 //      sender_id: currentUserId,
				 //      recipient_id: $('#new-recipientvalue').val() || "",
				 //      all_day: allDay 
				 //    }}
		   //    });
	    //   };
	      //emptying modal
	      //else
	      //error messages
	    });
      $('#calendar').fullCalendar('unselect');
    },
    //showing and updating calendar event with bootstrap modal
    eventClick:  function(event, jsEvent, view) {
      $('#edit-modaltitle').html(event.title);
      $('#edit-startvalue').val(event.start);
      if (event.end) {
      	$('#edit-endvalue').val(event.end);
    	};
    	// if (event.allDay) {
     //  	$('#edit-alldayvalue').val(event.allDay);
    	// };
    	if (event.recipientId == currentUserId) {
    		$('#edit-uservalue').text("Sender: " + event.senderName);
    	}
    	else {
    		$('#edit-uservalue').text("Recipient: " + event.recipientName);
    	};
    	if (event.body) {
    		$('#edit-bodyvalue').val(event.body);
    	};
      //$('#eventUrl').attr('href',event.url);
      $('#fullcallmodal-edit').modal('show');
    	$('#event-form-update').click(function() {
	 			$('#fullcallmodal-edit').modal('hide');
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
				$('#calendar').fullCalendar('removeEvents', event.id);
				$('#calendar').fullCalendar('renderEvent', newEvent, true);
				updateEvent(newEvent);
			});
			$('#event-form-delete').click(function() {
	 			$('#fullcallmodal-edit').modal('hide');
				$('#calendar').fullCalendar('removeEvents', event.id);
				deleteEvent(event);
			});
			return false;
    }
  });

};

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

            $.ajax({
        url : "/users/" + currentUserId + "/events/",
        type : "GET",
        data : { form_id: JSON.stringify(event.id) }
      });