// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http: //coffeescript.org/

function updateFromCourse() {
	$("#first_preference").empty();
	$('#second_preference').empty();
	$('#third_preference').empty();
	$.ajax({
		type: "GET",
		dataType: "json",
		data: $.param({
			time_block: {
				course: $("#course").find(":selected").val()
			}
		}),
		url: "/time_blocks",
		success: function(json) {
			$("#second_preference").append('<option value="">');
			$("#third_preference").append('<option value="">');
			$.each(json, function(key, value) {
				$("#first_preference").append(
					$("<option></option>").attr("value", value.id).text(value.display_block)
				);
				$("#second_preference").append(
					$("<option></option>").attr("value", value.id).text(value.display_block)
				);
				$("#third_preference").append(
					$("<option></option>").attr("value", value.id).text(value.display_block)
				);
			});
			updateFromTimeBlock(1);
			updateFromTimeBlock(2);
			updateFromTimeBlock(3);
		},
	});
};

function updateFromTimeBlock(preference) {
	if (preference === 1) {
		$("#first_date").empty();
	} else if (preference === 2) {
		$("#second_date").empty();
	} else if (preference === 3) {
		$("#third_date").empty();
	}
	$.ajax({
		type: "GET",
		dataType: "json",
		url: "/courses/" + $("#course").find(":selected").val(),
		success: function(json) {
			if (preference === 1) {
				$.each(json["available_dates"], function(key, value) {
					$("#first_date").append(
						$("<option></option>").attr("value", value[1]).text(value[0])
					);
				});
			} else if (preference == 2) {
				$("#second_date").append('<option value="">');
				$.each(json["available_dates"], function(key, value) {
					$("#second_date").append(
						$("<option></option>").attr("value", value[1]).text(value[0])
					);
				});
			} else if (preference == 3) {
				$("#third_date").append('<option value="">');
				$.each(json["available_dates"], function(key, value) {
					$("#third_date").append(
						$("<option></option>").attr("value", value[1]).text(value[0])
					);
				});
			}
		},
	});
};

$(document).on('turbolinks:load', function() {
	updateFromCourse();
});