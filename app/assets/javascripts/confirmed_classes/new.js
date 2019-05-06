function updateFromCourseCreate() {
	$("#confirmed_class_teaching_assistant_id").empty();
	$("#confirmed_class_preference_id").empty();
	$("#request-list").empty();
	$.ajax({
		type: "GET",
		dataType: "json",
		url: "/cursos/" + $("#course").find(":selected").val() + "/ayudantes",
		success: function(json) {
			$.each(json, function(key, value) {
				$("#confirmed_class_teaching_assistant_id").append(
					$("<option></option>").attr("value", value.id).text(value.name)
				);
			});
		},
	});
	$.ajax({
		type: "GET",
		dataType: "json",
		url: "/peticiones",
		data: $.param({
			course: $("#course").find(":selected").val(),
		}),
		success: function(json) {
			$.each(json, function(key, value) {
				$.each(value.preferences, function(key, value) {
					$("#confirmed_class_preference_id").append(
						$("<option></option>").attr("value", value.id).text(value.display_preference)
					);
				});
				$("#request-list").append(
					"<li><input type='checkbox' value='" + value.id + "' " +
					"name='confirmed_class[request_ids][]' id='confirmed_class_request_ids_" +
					value.id + "' >" + value.display_request +
					"</input>" +
					"</li>"
				);
			});
		},
	});
};


$(document).on('turbolinks:load', function() {
	if ($('body.new').length) {
		updateFromCourseCreate();
	};
});