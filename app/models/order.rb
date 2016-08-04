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
	#訂單需退款
	scope  :refund_orders, 	-> {where(aasm_state: ["refund_processing", "return_processing"])}
	#申請退貨訂單
	scope  :return_orders,  -> {where(aasm_state: "return_processing" )}
	#已取號尚未付款訂單
	scope  :number_received_orders,  -> {where(aasm_state: "number_received" )}
	#異動完成訂單
	scope  :transfer_orders, -> {where(aasm_state: [:order_cancelled, :good_returned, :good_return_failed])}
	#信用卡付款訂單
	scope  :cc_orders, 			-> {where(payment_method: "credit_card")}
	#WebATM訂單
	scope  :wa_orders, 			-> {where(payment_method: "web_atm")}
	#超商繳費訂單
	scope  :cvs_orders, 			-> {where(payment_method: "cvs")}
	#ATM轉帳訂單
	scope  :vacc_orders, 			-> {where(payment_method: "vacc")}

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
		cart.items.each do |cart_item|
			item = self.items.build 
			item.product_name = cart_item.title
			item.quantity = cart.cart_items.find_by(product_id: cart_item).quantity
			item.price = cart_item.price
			item.save
		end	
	end

	def calculate_total!(cart)
		self.total = cart.total_price + 100
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
	def store_payment_info(info, hash={})
		if hash[:payment_type] == "cvs"
		  deadline = Time.zone.now.advance(days: 1)
		else
		  deadline = Time.zone.now.advance(days: 3).end_of_day
		end 
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
		
		event :refund_completed, after_commit: :done!  do
			transitions from: :refund_processing,				to: :order_cancelled
		end	

		event :cancel_order do 
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
