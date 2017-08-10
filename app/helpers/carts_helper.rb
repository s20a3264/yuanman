module CartsHelper

	def render_cart_items_count(cart)
		cart.items.count	
	end

	#購物車商品總價
	def render_cart_total_price(items, cart_items)
		@sum = 0
		items.each do |product|
			@sum += sum(cart_items, product)
		end
		@sum	
	end

	#試算運費
	def trial_shipping_cost
		@shipping_cost = @sum >= 1000 ? 0 : @setting.shipping_cost
		@shipping_cost 
	end	

	#訂單應付總金額
	def render_total_amount
		@sum + @shipping_cost
	end

	#購物車單件商品小計
	def sum(cart_items_hash, product)
		product.price * find_cart_items_quantity(cart_items_hash, product)
	end

	def find_cart_items_quantity(cart_items_hash, product)
		cart_items_hash[product.id]
	end


end
