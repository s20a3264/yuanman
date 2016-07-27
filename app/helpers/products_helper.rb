module ProductsHelper
	# 商品數量下拉選單範圍
	def product_quantity_range(product)
		array = []
		if product.quantity > 10
			10.times do |i|
				n = i + 1
				array << [n.to_s, n]
			end
		else	
			product.quantity.times do |i|
				n = i + 1
				array << [n.to_s, n]
			end
		end	
		array	
	end
end
