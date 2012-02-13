$(document).ready(function() {
	$("#web-debug-toolbar .hidden-panel").hide();

	$("#web-debug-toolbar .panel-toggle-button").hover(function() {
		if ($("#web-debug-toolbar #" + this.rel).is(":hidden"))
			$("#web-debug-toolbar .hidden-panel").hide()

		$("#web-debug-toolbar #" + this.rel).toggle();
	});

	$("#web-debug-toolbar #toolbar-toggle-button").click(function() {
		$(this).text($("#web-debug-toolbar #toolbar-panels").is(":hidden") ? '>' : '<');
		$("#web-debug-toolbar .hidden-panel").hide();
		$("#web-debug-toolbar #toolbar-panels").toggle();
	});
});