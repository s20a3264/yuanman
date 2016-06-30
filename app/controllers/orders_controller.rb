class OrdersController < ApplicationController
	before_action :authenticate_user!, except: :pay2go_cc_notify

	before_action :cart_items_to_hash, only: [:create]

	protect_from_forgery except: :pay2go_cc_notify


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
		@order.make_payment!

		flash[:notice] =  "成功完成付款"
		redirect_to account_orders_path
	end

  def pay2go_cc_notify
    @order = Order.find_by_token(params[:id])

    if params["Status"] == "SUCCESS"

      @order.make_payment!

      if @order.is_paid?
        flash[:success] = "信用卡付款成功"

        redirect_to account_orders_path
      else
        render text: "信用卡付款失敗"
      end
    else
      render text: "交易失敗"
    end
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
