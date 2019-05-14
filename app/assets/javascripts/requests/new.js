function eventCalendar(event) {
    // Initialize calendar
    $('#event_calendar').fullCalendar({
        // Locale and timezone
        locale: 'es-CL',
        timezone: 'local',
        // Calendar display setup
        weekends: false,
        defaultView: 'agendaWeek',
        header: {
            left: 'prev',
            center: 'title',
            right: 'next',
        },
        columnFormat: 'ddd D/M',
        minTime: "08:30:00",
        maxTime: "18:30:00",
        height: "auto",
        validRange: function(nowDate) {
            // nowDate = moment("2019-05-28 12:00");
            var shift = 0;
            switch (nowDate.day()) {
                case 6:
                    shift += 1;
                case 0:
                    shift += 1;
                    break;
            }
            var start = nowDate.clone().add(shift, 'days').add(1, 'weeks');
            var end = nowDate.clone().add(shift, 'days').add(3, 'weeks');
            return {
                start: start.format("YYYY-MM-DD"),
                end: end.format("YYYY-MM-DD"),
            };
        },
        // Event display setup
        eventColor: "green",
        events: [],
        // Interaction
        eventClick: function(calEvent, jsEvent, view) {
            // Count selected events
            var selected_events = $("#event_calendar").fullCalendar('clientEvents').filter(function(event) {
                return (event.color === "gold");
            }).length;
            if (calEvent.title == 'Seleccionado') {
                // Toggle off
                calEvent.color = 'green';
                calEvent.textColor = 'white';
                calEvent.title = 'Disponible';
            } else if (selected_events === 3) {
                // Upper limit reached
                alert("Solo puedes seleccionar hasta 3 opciones");
            } else {
                // Toggle on
                calEvent.color = 'gold';
                calEvent.textColor = 'black';
                calEvent.title = 'Seleccionado';
            };
            // Update event in calendar
            $('#event_calendar').fullCalendar('updateEvent', calEvent);
            // Update display in form
            updatePreferenceDisplay();
        },
    });
    // Hack to fillCalendar only when first loaded, because
    // it causes events duplication with views/requests/new.js
    if (typeof event === 'object') {
        fillCalendar();
    }
};

function clearCalendar() {
    // Clear calendar to avoid caching
    $('#event_calendar').fullCalendar('removeEvents');
    $('#event_calendar').html('');
};

function fillCalendar() {
    // Load time blocks data from server as json
    $('#event_calendar').fullCalendar('removeEvents');
    updatePreferenceDisplay();
    $.ajax({
        type: "GET",
        dataType: "json",
        data: $.param({
            course: $("#course").find(":selected").val(),
        }),
        url: "/modulos/opciones",
        success: function(events) {
            events = events.map(function(event) {
                event.start = moment(event.start, 'YYYY-MM-DD HH:mm:ss Z');
                event.end = moment(event.end, 'YYYY-MM-DD HH:mm:ss Z');
                return event;
            });
            $("#event_calendar").fullCalendar("renderEvents", events, true);
        },
    });
};

function updatePreferenceDisplay() {
    // Show selected events from calendar in a ul element in form
    var events = $("#event_calendar").fullCalendar('clientEvents').filter(function(event) {
        return (event.color === "gold");
    });
    $("#preferences ul").empty();
    var preferences_date_hifs = $("#preferences [name='request[preferences_dates][]']:hidden");
    var preferences_tbs_hifs = $("#preferences [name='request[preferences_time_blocks][]']:hidden");
    preferences_date_hifs.val('');
    preferences_tbs_hifs.val('');
    var index;
    for (index = 0; index < 3; index++) {
        if (index in events) {
            var event = events[index];
            // Hidden values
            preferences_date_hifs[index].value = event.start.format("L");
            preferences_tbs_hifs[index].value = event.internal_id;
            // Shown value
            var time_block_as_string = "<li>";
            var date = event.start.format("dddd, MM [de] MMMM");
            time_block_as_string += "<b>" + date.charAt(0).toUpperCase() + date.slice(1) + "</b>";
            time_block_as_string += ", de ";
            time_block_as_string += event.start.format("HH:mm");
            time_block_as_string += " a ";
            time_block_as_string += event.end.format("HH:mm");
            time_block_as_string += "</li>"
            $("#preferences ul").append(time_block_as_string);
        } else {
            var instruction = "<li><i>Selecciona un módulo disponible en el calendario</i></li>";
            $("#preferences ul").append(instruction);
        }
    }
};

$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:before-cache', clearCalendar);
