class Manager::OrdersController < ManagerController

	def index
		@orders = Order.includes(:user).paginate(:page => params[:page],:per_page => 5).order('id DESC')
	end

	def show
		@order = Order.find(params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end


	def shipped
		@order = Order.find_by(id: params[:id])
		@order.ship!

		redirect_to :back
	end

	def cancel
		@order = Order.find_by(id: params[:id])
		@order.cancell_order! 

		redirect_to :back
	end

	def return
		@order = Order.find_by(id: params[:id])
		@order.return_good!

		redirect_to :back
	end
end
