class Order < ActiveRecord::Base
	include AASM

	belongs_to :user

	has_many :items, class_name: "OrderItem", dependent: :destroy
	has_one  :info,  class_name: "OrderInfo", dependent: :destroy
	has_many :comments, as: :commentable

	#查詢天數內訂單
	scope :last_days, -> (interval) { where(created_at: (Time.zone.now.to_date - interval.day)..Time.zone.now)}

	#待處理訂單
	scope  :undone_orders, 	-> {where(undone: true)}
	#已付款訂單
	scope  :paid_orders,   	-> {where(aasm_state: "paid")}
	#付款失敗訂單
	scope  :fail_orders,    -> {where(aasm_state: "payment_fail")}
	#訂單需退款
	scope  :refund_orders, 	-> {where(aasm_state: ["refund_processing", "return_processing"])}
	#申請退貨訂單
	scope  :return_orders,  -> {where(aasm_state: "return_processing" )}
	#已取號尚未付款訂單
	scope  :number_received_orders,  -> {where(aasm_state: "number_received" )}
	#異動完成訂單
	scope  :transfer_orders, -> {where(aasm_state: [:order_cancelled, :good_returned, :good_return_failed])}
	#信用卡付款訂單
	scope  :cc_orders, 			-> {where(payment_method: "CREDIT")}
	#WebATM訂單
	scope  :wa_orders, 			-> {where(payment_method: "WEBATM")}
	#超商繳費訂單
	scope  :cvs_orders, 			-> {where(payment_method: "CVS")}
	#ATM轉帳訂單
	scope  :vacc_orders, 			-> {where(payment_method: "VACC")}

	accepts_nested_attributes_for :info

	before_create :generate_token, :generate_order_number

	def generate_token
		self.token = SecureRandom.uuid
	end

	def generate_order_number
		random_code = SecureRandom.uuid.gsub(/-/, '').upcase[0, 8]
		self.order_number = Time.zone.now.strftime("%y%m%d%H%M%S") + random_code
	end

	def build_item_cache_from_cart(cart)
		cart.items.each do |product|
			item = self.items.build 
			item.product_name = product.title
			item.product_id = product.id
			item.quantity = cart.cart_items.find_by(product_id: product).quantity
			item.price = product.price
			item.save
		end	
	end

	#寫入訂單總價，運費，繳費期限
	def calculate_total_and_deadline!(cart)
		shipping_cost = cart.total_price >= 1000 ? 0 : Setting.last.shipping_cost
		self.shipping_cost = shipping_cost
		self.total = cart.total_price + shipping_cost
		self.deadline = Time.zone.now.advance(days: 3).end_of_day
		self.save
	end

	def pay!
		self.update_columns(is_paid: true)
	end

	#儲存交易回傳訊息
	def store_trade_info(info)
		self.update_columns(trade_info: info)
	end

	#儲存非即時支付取號資訊以及繳費期限
	def store_payment_info(info)
		self.update_columns(payment_info: info, deadline: deadline)
	end

	def complete_payment(method)
		self.update_columns(payment_method: method, is_paid: true)
		self.make_payment!
  end

  def cancel
  	case self.aasm_state
  	when "order_placed"
  		self.cancel_order!
  	when "number_received"
  		self.cancel_order!
  	when "paid"
  		self.cancel_payment_order!
  	end	
  end

  #取消訂單後庫存數量返還
  def stock_update!
  	self.items.each do |item|
  		product = Product.find_by(id: item.product_id)
  		product.quantity += item.quantity
  		product.save
  	end	
  end

  #將訂單改為待處理
  def undone!
  	self.undone = true
  	self.save
  end

  #將訂單改為處理完成
  def done!
  	self.undone = false
  	self.save  	
  end

	aasm do 
		state :order_placed, initial: true
		state :number_received
		state :paid
		state :shipped
		state :refund_processing
		state :order_cancelled
		state :return_processing
		state :good_returned
		state :good_return_failed

		#結帳失敗訂單	
		state :payment_fail


		#結帳失敗
		event :fail_to_pay do
			transitions from: :order_placed,          to: :payment_fail
		end

		event :take_a_number do
			transitions from: :order_placed,						to: :number_received
		end
		
		event :nonreal_time_payment, after_commit: :undone! do
			transitions from: :number_received,					to: :paid
		end

		event :make_payment, after_commit: :undone! do 
			transitions from: [:order_placed, :number_received], to: :paid
		end
		
		event :ship, after_commit: :done!  do 
			transitions from: :paid, 										to: :shipped
		end

		event :cancel_payment_order, after_commit: :undone! do 
			transitions from: :paid,										to: :refund_processing 
		end
		
		event :refund_completed, after_commit: [:done!, :stock_update!]  do
			transitions from: :refund_processing,				to: :order_cancelled
		end	

		event :cancel_order, after_commit: :stock_update! do 
			transitions from: [:order_placed, :number_received], 	to: :order_cancelled
		end	

		event :request_good_returned, after_commit: :undone! do
			transitions from: :shipped, 								to: :return_processing
		end
		
		event :return_good, after_commit: :done!  do 
			transitions from: :return_processing,			  to: :good_returned
		end	
		
		event :return_fail, after_commit: :done!  do
			transitions from: :return_processing, 			to: :good_return_failed
		end		

	end



end
