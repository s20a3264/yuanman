class Account::OrdersController < ApplicationController
	before_action :authenticate_user!

	def index
		@orders = current_user.orders.order(id: :DESC )
	end


	def cancel
		@order = Order.find_by(id: params[:id])
		@comment = @order.comments.build(comment_params)
		@comment.save
		@order.cancell_order! 
		flash[:success] = "訂單已取消"
		redirect_to order_path(@order.token)
		rescue
			flash[:warning] = "取消訂單失敗，此訂單可能已經出貨"
			redirect_to order_path(@order.token)
	end

	def ask_for_return
		@order = Order.find_by(id: params[:id])
		@order.ask_for_good_returned!

		flash[:success] = "已申請退貨"
		redirect_to :back
	end

	# message board
	def message_board
		@order = Order.find_by(token: params[:id])
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
		@order = Order.find_by(token: params[:id])
		@comment = @order.comments.build
	end

	private
		def comment_params
			params.require(:comment).permit(:title, :content, :user_name)
		end
end
