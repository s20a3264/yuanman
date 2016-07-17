class Manager::OrdersController < ManagerController

	def index
		@orders = Order.includes(:user).order('id DESC').page(params[:page])
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
		rescue
			flash[:warning] = "出貨動作失敗，此訂單可能已經被用戶取消！"
			redirect_to manager_order_path(@order)	
	end

	def cancel
		@order = Order.find_by(id: params[:id])
		@order.cancell_order! 
		redirect_to :back
		rescue
			flash[:warning] = "取消訂單失敗，此訂單可能已經被用戶取消！"
			redirect_to manager_order_path(@order)
	end

	def return
		@order = Order.find_by(id: params[:id])
		@order.return_good!

		redirect_to :back
	end

	def return_fail
		@order = Order.find_by(id: params[:id])
		@order.return_fail!

		redirect_to :back		
	end
end
