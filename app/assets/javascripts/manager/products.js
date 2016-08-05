var loadFile = function(event) {
	var output = document.getElementById('output');
	output.src = URL.createObjectURL(event.target.files[0]);
};


/* 新增或顯示原來分類 */
$(document).on('ready page:load', function() {
	$("#category-form").hide();
	$('#old-category').hide();
	$('.category-controller a').on('click', function(evt) {
		evt.preventDefault();
		$("#category-form").toggle();
		$('#category-select').toggle();
		$('#new-category').toggle();
		$('#old-category').toggle();
	});
});