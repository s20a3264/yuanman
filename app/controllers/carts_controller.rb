class CartsController < ApplicationController
	before_action :authenticate_user!, only: [:checkout]
	before_action :cart_items_to_hash, only: [:index, :checkout]

	def index
		@items = current_cart.items.includes(:photo)
	end

	def refresh
		cart_item = current_cart.cart_items.find_by(product_id: params[:product_id])
		cart_item.quantity = params[:quantity]
		cart_item.save

		redirect_to carts_path
	end

	def checkout
		@order = current_user.orders.build
		@info = @order.build_info
	end

	def delete_cart_item
		cart_item = current_cart.cart_items.find_by(product_id: params[:product_id])
		cart_item.destroy

		flash[:notice] = "你已將 #{params[:product_title]} 從購物車刪除"
		redirect_to carts_path
	end

	def clean
		current_cart.clean!

		flash[:warning] = "購物車已清空"
		redirect_to carts_path
	end

	private


end
