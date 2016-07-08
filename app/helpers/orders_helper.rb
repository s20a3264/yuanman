module OrdersHelper
	#單項商品小計
	def order_item_sum(item)
		item.price * item.quantity
	end

	#商品總價
	def render_order_total_price(items)
		sum = 0
		items.each do |item|
			sum += order_item_sum(item)
		end
		sum	
	end




	#AASM翻譯
	def render_order_state(order)
		color = order.aasm_state == "paid" ? "green" : "none"
		content_tag(:span, t("orders.order_state.#{order.aasm_state}"), class: color)
	end

	#已付款or未付款
	def render_order_paid_state(order)
		if order.is_paid?
			content_tag(:span, "已付款", class: "green")
		else
			content_tag(:span, "未付款", class: "red")
		end		
	end
end
