module CartsHelper

	def render_cart_items_count(cart)
		cart.items.count	
	end

	def render_cart_total_price(items, cart_items)
		sum = 0
		items.each do |product|
			sum += sum(cart_items, product)
		end
		sum	
	end

	def find_cart_items_quantity(cart_items, product)
		cart_items[product.id]
	end

	def sum(cart_items, product)
		product.price * find_cart_items_quantity(cart_items, product)
	end
end
