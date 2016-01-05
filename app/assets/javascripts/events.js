var ready = function() {
  //getting current user from body tag
	currentUserId = $('#bodycurrentuser').data('currentuserid');
  eventUserId = $('#calendar').data('eventuserid');

	//fullcalendar default settings
  $('#calendar').fullCalendar({
    loading: function(isLoading, view) {
      if (isLoading) {
        $('.calendar-loading').show();
    //     //$('.sp').show();
    //     $(".calendar-spin").spin({
    //       lines: 12, // The number of lines to draw
    //       length: 7, // The length of each line
    //       width: 9, // The line thickness
    //       radius: 30, // The radius of the inner circle
    //       color: '#ff0000', // #rgb or #rrggbb
    //       speed: 1, // Rounds per second
    //       trail: 60, // Afterglow percentage
    //       shadow: false // Whether to render a shadow
    //     });
      }
      else {
        $('.calendar-loading').hide();
    //     //$('.sp').hide();
    //     $(".calendar-spin").spin(false);
      };
    },
    timezone: 'local',
    editable: false,
    allDayDefault: false,
    header: {
      left: 'prev,next today', 
      center: 'title', 
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek', 
    height: 500, 
    slotMinutes: 30,
    eventSources: [{  url: '/users/' + eventUserId + '/events' }],
    lazyFetching: true,
    startParam: 'start',
    endParam: 'end',
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
			return false;
    }
  });
};

$(document).ready(ready);
$(document).on("page:load", ready);