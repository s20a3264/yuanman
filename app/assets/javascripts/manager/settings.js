$(document).on('ready page:load', function() {
	var width = $('#myCarousel').width();
	var height = width * 0.34;
	 $('#myCarousel').height(height);

	$( window ).resize(function() {
		var width = $('#myCarousel').width();
		var height = width * 0.34;
		 $('#myCarousel').height(height);
	});
	
});
