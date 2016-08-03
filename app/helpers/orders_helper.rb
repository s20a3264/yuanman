module OrdersHelper
	#設定付款時限
	def set_expire_date(order)
		date = order.created_at.advance(days: 1)
		date.to_s(:Ymd)
	end

	#將總秒數格式化
	def formatted_duration(total_seconds)
		hours = total_seconds / (3600)
		minutes = (total_seconds / 60) % 60
		seconds = total_seconds % 60
		"#{hours}#{minutes}#{seconds}"
	end
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
		content_tag(:span, t("orders.order_state.#{order.aasm_state}"), class: "order-state #{order.aasm_state}")
	end

	def render_order_state_manager(order)
		content_tag(:span, t("orders.order_state_manager.#{order.aasm_state}"), class: "order-state #{order.aasm_state}")
	end	

	#已付款or未付款
	def render_order_paid_state(order)
		if order.is_paid?
			content_tag(:span, "已付款", class: "green")
		else
			content_tag(:span, "未付款", class: "red")
		end		
	end

	#付款方式翻譯
	def render_payment_method(method)
		t("payment_method.#{method}")
	end

	#顯示取號付款資訊
	def render_payment_info(info)
		if info["PaymentType"] == "CVS"
			render 'cvs_payment_info'
		elsif info["PaymentType"] == "VACC"
			render 'vacc_payment_info'
		end			
	end



end
