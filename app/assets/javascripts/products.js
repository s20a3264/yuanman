$(document).on('ready page:load', function() {
	//購物車ajax，動畫
	$('#product-delegate').on('click', '.add_to_cart', function() {
		var quantity = $('#product-delegate select').find(":selected").val();
		$.ajax({
			url: '/add_to_cart',
			type: 'POST',
			datatype: 'json',
			data: {id: $(this).data('product-id'), quantity: quantity},
			timeout: 10000,
			beforeSend: function() {
				$('#cart-box').stop();
				$('.as span').removeClass('animated fadeIn')
				$('.ajax-cart').removeClass('animated wobble');
				$('.ajax-cart').addClass('animated infinite flipInY');
			},
			success: function(respond) {
				$('.ajax-cart').removeClass('animated infinite flipInY');
				$('#cart-box').css({"backgroundColor":"#7b868a"});
				$('#cart-box').animate({backgroundColor: "#fff"}, 1000);
				$('.as span').html(respond['quantity']).addClass('animated fadeIn');
				$('.ajax-cart').addClass('animated wobble');
			},
			complete: function() {
			},
			error: function() {
				$('.ajax-cart').removeClass('animated infinite flipInY');
			}
		});
	});
	//購物車ajax，動畫end

	//打開漢堡條時取消動畫
	$('.lines-button').on('click', function() {
		$('.ajax-cart').removeClass("wobble animated");
		$('.as span').removeClass('animated fadeIn');
		console.log("1111");
	});
});