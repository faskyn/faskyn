var ready = function() {
  //getting current user from body tag
	currentUserId = $('#bodycurrentuser').data('currentuserid');
  eventUserId = $('#calendar').data('eventuserid');

	//fullcalendar default settings
  $('#calendar').fullCalendar({
    loading: function(isLoading, view) {
      if (isLoading) {
        $('.calendar-loading').show();
      }
      else {
        $('.calendar-loading').hide();
      };
    },
    timezone: 'local',
    timezoneParam: 'UTC',
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
    }
  });
};

$(document).ready(ready);
$(document).on("page:load", ready);