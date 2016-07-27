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
		@comment = @order.comments.build(comment_params)

		if @comment.save
			@order.cancel
			flash[:success] = "訂單已取消"
			redirect_to manager_order_path(@order)
		else
			render :message_of_cancel
		end	
	end

	def refund
		@order = Order.find_by(id: params[:id])
		@order.refund_completed!

		redirect_to :back
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

	# message board
	def message_board
		@order = Order.find_by(id: params[:id])
		@comments = @order.comments
		@comment = @order.comments.build

	end

	def create_message
		@order = Order.find_by(id: params[:id])
		@comments = @order.comments
		@comment = @order.comments.build(comment_params)

		if @comment.save
			redirect_to :back		
		else
			render :message_board
		end	
	end

	def message_of_cancel
		@order = Order.find_by(id: params[:id])
		@comment = @order.comments.build
	end

	private
		def comment_params
			params.require(:comment).permit(:title, :content, :user_name)
		end	
end
