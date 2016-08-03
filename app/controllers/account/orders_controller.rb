class Account::OrdersController < ApplicationController
	before_action :authenticate_user!

	def index
		@orders = current_user.orders.order(id: :DESC )
	end


	def cancel
		@order = Order.find_by(id: params[:id])
		@comment = @order.comments.build(comment_params)
		if @comment.save
			@order.cancel
			flash[:success] = "訂單已取消"
			redirect_to order_path(@order.token)
		else	
			render :message_of_cancel
		end	
		rescue
			flash[:warning] = "取消訂單失敗，此訂單可能已經出貨"
			redirect_to order_path(@order.token)
	end

	def request_return
		@order = Order.find_by(id: params[:id])
		@comment = @order.comments.build(comment_params)
		if @comment.save
			@order.request_good_returned!
			flash[:success] = "已申請退貨"
			redirect_to order_path(@order.token)
		else
			render "message_of_return"
		end
		rescue
			flash[:warning] = "申請退貨失敗，請再試一次"
			redirect_to order_path(@order.token)			
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

	def message_of_return
		@order = Order.find_by(token: params[:id])
		@comment = @order.comments.build		
	end

	#取號資訊
	def payment_info
		@order = Order.find_by(token: params[:id])
		@payment_info = @order.payment_info
	end

	private
		def comment_params
			params.require(:comment).permit(:title, :content, :user_name)
		end
end
