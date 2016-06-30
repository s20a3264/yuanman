class Account::OrdersController < ApplicationController
	before_action :authenticate_user!

	def index
		@orders = current_user.orders.order(id: :DESC )
	end

	def cancel
		@order = Order.find_by(id: params[:id])
		@order.cancell_order! 

		flash[:success] = "訂單已取消"
		redirect_to :back
	end
end
