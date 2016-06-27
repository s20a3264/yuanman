class OrdersController < ApplicationController
	before_action :authenticate_user!

	before_action :cart_items_to_hash, only: [:create]

	def create
		@order = current_user.orders.build(order_params)
		error_info = current_cart.stock_check
		if error_info.empty?
			if @order.save
				Product.set_inventory!(current_cart)
				@order.build_item_cache_from_cart(current_cart)
				@order.calculate_total!(current_cart)
				
				current_cart.clean!
				redirect_to order_path(@order.token)
			else	
				render 'carts/checkout'	
			end
		else
			flash[:danger] = error_message(error_info)

			redirect_to carts_path
		end		
	end

	def show
		@order = Order.find_by(token: params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end

	def pay_with_credit_card
		@order = Order.find_by(token: params[:id])
		@order.set_payment_with!("credit_card")
		@order.pay!

		flash[:notice] =  "成功完成付款"
		redirect_to order_path(@order.token)
	end

	private

	def order_params
		params.require(:order).permit(info_attributes: [
																										:shipping_name, 
																										:shipping_address] )
	end

	def error_message(hash)
		d_name = ""
		c_name = ""

		hash[:delete].each { |i| d_name += "#{i}，"} 			if !hash[:delete].blank?
		hash[:change].each { |i| c_name += "#{i}，"} 			if !hash[:change].blank?
 
		d_message = "#{d_name}已被刪除。" 								   if !hash[:delete].blank?
		c_message = "#{c_name}已被系統修改為目前可購買數量，"  if !hash[:change].blank?


		"很抱歉，由於商品庫存不足，您的購物車內商品 ： #{c_message}#{d_message}"	
	end
end
