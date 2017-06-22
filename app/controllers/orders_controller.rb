class OrdersController < ApplicationController
	before_action :authenticate_user!, except: [:pay2go_cc_return, :pay2go_cc_notify, :pay2go_wa_return,
																							:pay2go_wa_notify, :pay2go_atm_complete, :realtime_return,
																						  :realtime_notify, :non_realtime_customer, :non_realtime_notify,
																						  #新版智付寶
																							:pay2go_return, :pay2go_notify]

	before_action :set_pay2go_json, only: [:pay2go_cc_return, :pay2go_cc_notify, :pay2go_wa_return,
		                                     :pay2go_wa_notify, :realtime_return, :realtime_notify,
		                                     :non_realtime_customer, :non_realtime_notify]
	
	before_action :cart_items_to_hash, only: [:create]

	protect_from_forgery except: [:pay2go_cc_notify, :pay2go_cc_return, :pay2go_wa_return,
																:pay2go_wa_notify, :pay2go_atm_complete, :realtime_return,
																:realtime_notify, :non_realtime_customer, :non_realtime_notify,
																#新版智付寶
																:pay2go_return, :pay2go_notify]


	def create
		@order = current_user.orders.build(order_params)
		current_user.info_build(order_params) if !current_user.info["shipping_name"]
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
			flash[:warning] = error_message(error_info)

			redirect_to carts_path
		end		
	end

	def show
		@order = current_user.orders.find_by(token: params[:id])
		@order_info = @order.info
		@order_items = @order.items
	end

	def pay2go_notify
		
	end

	def pay2go_return
		params['Status'] = "SUCCESS"
		tradeinfo = params['TradeInfo']
		@a = Pay2goService.aes_decrypt(ENV['hash_key'], tradeinfo)

	end

	#pay2go舊版
	def pay2go_cc_return
		if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
			@order.complete_payment("credit_card", @json_data['Result'])
			flash[:success] = "信用卡付款完成"
			redirect_to order_path(@order.token)
		elsif @json_data['Status'] == "SUCCESS" && @check_code == @result['CheckCode']
			flash[:success] = "信用卡付款完成"
			redirect_to order_path(@order.token)
		else
			flash[:warning] = "交易失敗,#{@json_data["Message"]}"
			redirect_to order_path(@order.token)
		end	
	end

  def pay2go_cc_notify
    if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
    	 @order.complete_payment("credit_card", @json_data['Result'])
    end
  end

  def pay2go_wa_return
		if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
			@order.complete_payment("web_atm", @json_data['Result'])
			flash[:success] = "WebATM付款完成"
			redirect_to order_path(@order.token)
		elsif @json_data['Status'] == "SUCCESS" && @check_code == @result['CheckCode']
			flash[:success] = "WebATM付款完成"
			redirect_to order_path(@order.token)
		else
			flash[:warning] = "交易失敗,#{@json_data["Message"]}"

			redirect_to order_path(@order.token)
		end	
  end

  def pay2go_wa_notify
  	if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
  		 @order.complete_payment("web_atm", @json_data['Result'])
  	end
  end

  def realtime_return
  	@order.store_trade_info(@result) if @order.trade_info.empty?
  	if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
  		@order.complete_payment(@payment_type)
  		flash[:success] = @message
			redirect_to order_path(@order.token)
		elsif @json_data['Status'] == "SUCCESS" && @check_code == @result['CheckCode']
			flash[:success] = "WebATM付款完成"
			redirect_to order_path(@order.token)
		else
			flash[:warning] = "交易失敗,#{@json_data["Message"]}"

			redirect_to order_path(@order.token)
		end	  		
  end

  def realtime_notify
  	@order.store_trade_info(@result) if @order.trade_info.empty?
  	if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
  		 @order.complete_payment(@payment_type)
  	end  	
  end

  def non_realtime_customer
  	if @json_data['Status'] == "SUCCESS" && @check_code == @result['CheckCode']
  		@order.take_a_number!

  		@order.store_payment_info(@result, payment_type: @payment_type)
  		flash[:success] = "取號成功"

  	  redirect_to payment_info_account_order_path(@order.token)
  	end
  	rescue
  		flash[:warning] = "取號失敗，請重新嘗試或選擇其他付款方式" 
  		redirect_to order_path(@order.token)
  end

  def non_realtime_notify
  	@order.store_trade_info(@result)
  	if @json_data['Status'] == "SUCCESS" && @order.is_paid == false && @check_code == @result['CheckCode']
  		 @order.complete_payment(@payment_type)
  	end    	
  end


	private

	def order_params
		params.require(:order).permit(info_attributes: [
																										:shipping_name, 
																										:shipping_address,
																										:postal_code,
																										:phone_number] )
	end

	def error_message(hash)
		d_name = ""
		c_name = ""

		hash[:delete].each { |i| d_name += "#{i}，"} 			if !hash[:delete].blank?
		hash[:change].each { |i| c_name += "#{i}，"} 			if !hash[:change].blank?
 
		d_message = "#{d_name}已被刪除。" 								  if !hash[:delete].blank?
		c_message = "#{c_name}已被系統修改為目前可購買數量，"  if !hash[:change].blank?


		"很抱歉，由於商品庫存不足，您的購物車內商品 ： #{c_message}#{d_message}"	
	end

	def set_pay2go_json
		@order = Order.find_by_token(params[:id])
		@json_data = JSON.parse(params["JSONData"])
		@result = JSON.parse(@json_data['Result'])
		@check_code = Pay2goService.new(@order, TradeNo: @result['TradeNo']).check("check_code")

		case @result['PaymentType']
		when "CREDIT"
			@payment_type = "credit_card"
			@message = "信用卡付款完成"
		when "WEBATM"
			@payment_type = "web_atm"
			@message = "WebATM付款完成"
		when "CVS"	
			@payment_type = "cvs"
		when "VACC"
			@payment_type = "vacc"	
		end 	
	end


end
