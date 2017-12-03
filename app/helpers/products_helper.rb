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

	#特價時顯示特價價格(products頁面)
	def render_price(product)
		if product.special?
			content_tag(:span, "NT$#{product.price} ", class: "", style: "text-decoration:line-through;") +
			content_tag(:span, " $#{product.special_price}", class: "red") 
		else
			content_tag(:span, "NT$#{product.price}", class: "")
		end	
	end

	#回傳真實價格
	def true_price(product)
		if product.special?
			product.special_price
		else	
			product.price
		end
	end

end
