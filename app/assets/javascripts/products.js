$(document).on('ready page:load', function() {
	$('.add_to_cart').on('click', function() {
		$.ajax({
			url: '/add_to_cart',
			type: 'GET',
			datatype: 'json',
			data: {id: $(this).data('product-id')},
			timeout: 10000,
			beforeSend: function() {
				$('#as span').removeClass('animated fadeIn')
				$('.ajax-cart').removeClass('animated wobble');
				$('.ajax-cart').addClass('animated infinite flipInY');
			},
			success: function(respond) {
				$('.ajax-cart').removeClass('animated infinite flipInY');
				$('#as span').html(respond['quantity']).addClass('animated fadeIn');
				$('.ajax-cart').addClass('animated wobble');
				console.log(respond)
			},
			complete: function() {
			},
			error: function() {
				$('.ajax-cart').removeClass('animated infinite flipInY');
			}
		});
	});
});