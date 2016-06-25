class OrdersController < ApplicationController
	before_action :authenticate_user!

	before_action :cart_items_to_hash, only: [:create]

	def create
		@order = current_user.orders.build(order_params)

		if @order.save
			@order.build_item_cache_from_cart(current_cart)
			@order.calculate_total!(current_cart)

			redirect_to order_path(@order.token)
		else

			render 'carts/checkout'	
		end	
	end

	def show
		@order = Order.find_by(token: params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end

	private

	def order_params
		params.require(:order).permit(info_attributes: [
																										:shipping_name, 
																										:shipping_address] )
	end
end
