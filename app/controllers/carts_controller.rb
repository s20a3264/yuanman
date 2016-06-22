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

	private


	def cart_items_to_hash
		@cart_items_hash = {}
		current_cart.cart_items.each do |item|
			@cart_items_hash[item.product_id] = item.quantity 
		end
		@cart_items_hash
	end
end
